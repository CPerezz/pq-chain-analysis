---
id: cf99575d-fixed-signer
title: "0xcf99575d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcf99575d5a8d1801307ba9827d689ac9fe56c149"
  family: "b5d2e6b05c83098aafa8ad51a119e4d7"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator/owner (0x7b29…786e)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The signer key is also the owner key. The rating is MEDIUM because only a function stops: the operator's own funds can still be withdrawn without the signature."
---

## Summary

The signer is a hard-coded constant EOA and nothing can replace it. If that key's account gets real code, buyToken stops working. The owner can still pull all funds out with withdraw/withdraw(address), so nothing is locked. Only the signed buy function breaks.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_a94685b8: require(0 == 0x7b29f3278655dddc2a39233d9934c86aa780786e, "FastHand::buyToken: invalid signature")
- signer constant = 703141377099528141209954659175704681015926618222 = 0x7b29…786e; the signer() getter returns it
- 0x7b29…786e has no code at block 26438999 (it is an EOA)
- The only setter, transferOwnership, writes only the owner (slot 0)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed or that accepts ERC-1271, and move funds out with the owner's withdraw functions.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
