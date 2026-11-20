---
id: f6463845-fixed-signer
title: "0xf6463845: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf6463845b0b9d9d33d8e2bcb6c628bc5cb1ad133"
  family: "9c343b7b86ff1686547c57501f36c04f"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The deployer redeploys with a new signer. Creators recover their deposits through finalWithdraw."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The other address-shaped constants (0x1ddc…, 0x18db…, 0x0000149959…) appear to be pieces of ASCII revert strings, not signers."
---

## Summary

Grab signatures must recover to the hard-coded address 0x8a4d…112a, which has no code today, and nothing can replace it. If that account gets real code, grabs stop working. Creators can still reclaim the remaining deposit through finalWithdraw after 24 hours, and the owner can also rescue funds, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_a007964e: require(address(var_v) == 0x8a4dc3aacabe67fc6d1231b884ccb283f54a112a, "Grab: Not eligible for grab")
- Verified facts: 0x8a4dc3aacabe67fc6d1231b884ccb283f54a112a is an EOA (no code) at block 26438999
- No function writes a signer. The only setter, transferOwnership (0xf2fde38b), writes the owner in slot 1.
- finalWithdraw: the creator (field_0) withdraws the remaining field_3 after field_4 = creation time + 0x015180 (1 day), with no signature needed

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed or that is checked through ERC-1271. Creators can use finalWithdraw to get back their remaining deposits.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
