---
id: deformeddonkeys-f6a3fdfe-fixed-signer
title: "DeformedDonkeys: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf6a3fdfeaa09b17dddbcff5e9b5cbc99dc4e2bbb"
  family: "f225827a0fb1f70109c0df199f13c78f"
  name: "DeformedDonkeys"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 144
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  note: "A signed mint dies with nothing locked, and the proceeds are the operator's and withdrawable, so MEDIUM."
---

## Summary

adoptDonkey needs an eligibility key from the hard-coded 0x20Ff…964C, recovered by plain ecrecover. With code there, the only paid mint dies. The owner still mints reserves and withdraws the ETH balance by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: DeformedDonkeys validateEligibilityKey: a constant address (0x20Ff…964C) signs mint eligibility; only the gated mint stops (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: validateEligibilityKey returns `ecrecover(msgHash,v,r,s) == 0x20Ff11c0383C3E84D2D251Ab77eBBaD667c2964C` (a literal); there is no other paid mint.
- withdraw() is onlyOwner and sends the whole balance; owner 0x37cf…cf57 has no code.
- The signer has no code at block 26438999; the contract holds 0.08 ETH of sale proceeds.

## Impact and exposure

- Value held at block 26,438,999: $144 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for funds; a new mint needs a new contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
