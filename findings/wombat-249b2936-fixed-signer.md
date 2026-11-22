---
id: wombat-249b2936-fixed-signer
title: "Wombat: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x249b29369ba6b90443437fd020e9f59bed524ff6"
  family: "a29e991e84381fbae2bd1d15a713998e"
  name: "Wombat"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1083
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-10-17
fix:
  layer: new-deployment
  who_acts: "Wombat deployer"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "No update path. Only the gated function dies; deposits return via refund (delayed until the 2028 deadline) → MEDIUM."
---

## Summary

contribute() needs a voucher from the immutable authorizationSigner. If that address takes code, new contributions stop; the campaign then fails at contributionDeadline, and refund() returns each 0.2 ETH with no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Wombat contribute: each contribution needs the immutable authorizationSigner's voucher; refund needs none, so held deposits stay reachable; only new contributions stop (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Wombat.sol: isValidAuthorization compares tryRecover with the immutable authorizationSigner
- authorizationSigner() = 0xAed75B940e9b4D4B111Cd0e9772a726a22252cdd, code 0x today
- refund() requires only hasFailed() (state CONTRIBUTING and past deadline) and the caller's own contribution: a direct call
- contributionDeadline = 1854566111 (2028-10); contributorCount = 3 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $1,083 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-17.

## Remediation

None on-chain; deposits are returned through refund after the deadline.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
