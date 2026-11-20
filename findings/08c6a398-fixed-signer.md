---
id: 08c6a398-fixed-signer
title: "0x08c6a398: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x08c6a3980dcd913aecb6963c7f93e9937fb7853d"
  family: "328f5c0842c7e6a3825ab35e85740e22"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1673
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner"
evidence:
  level: bytecode
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
  note: "MEDIUM: no update path, and the claim function dies; the funds are the operator's and leave via owner withdraw."
---

## Summary

A payment-claim contract: a90ae887 pays msg.sender on a signature from the constant 0x1b5722b8…6fb2. The owner withdraws and selfdestructs without a signature, so only the operator's money is involved.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: claimPayment: the recovered address must equal a constant (0x1b57…6fb2); the owner withdraws and kills without a signature, so the operator's own money (MEDIUM). Bytecode and names (no source).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: require(ecrecover(...) == 0x1b5722b86f72293b3d4baf81fcdb9f4342846fb2) before transfer; no setter
- withdraw(uint256) and kill() are owner-only; transferOwnership is available
- Constant signer and owner 0xfEDf…c92d have no code; balance 0.9269 ETH

## Impact and exposure

- Value held at block 26,438,999: $1,673 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner pays claimants directly or redeploys.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
