---
id: 618fba07-fixed-signer
title: "0x618fba07: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x618fba07c0e106ef742a6db6e9657f3246a961bb"
  family: "823e73ee0fe2e379e12aa08d160015ce"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new contract. Creators get their money back with finalWithdraw."
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
  note: "MEDIUM (main reviewer's LOW/MEDIUM rule): the signed function dies for good; other parties' assets leave by separate paths (owner/depositor withdraw, rescue, timeout), not by the same act. The other two constants (0x1ddc… and 0x18db…) and 0x0000149959… look like ASCII string data, not signers."
---

## Summary

Grabs need a signature from the hardcoded EOA 0x8a4d…112a. Nothing can replace it, there is no ERC-1271 or code check for it, and the contract can't be upgraded. If that key gets code, grabs stop. The deposits are not stuck: each creator can call finalWithdraw after 1 day without a signature, and the owner can also use the rescue functions.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_a007964e: require(address(var_v) == 0x8a4dc3aacabe67fc6d1231b884ccb283f54a112a, "Grab: Not eligible for grab")
- Verified facts: 0x8a4dc3aacabe67fc6d1231b884ccb283f54a112a is an EOA (no code)
- finalWithdraw: requires msg.sender == storage_map_b[id].field_0 (the creator) and block.timestamp > field_4, then pays out field_3. No signature is checked.
- Unresolved_7bb527ff (create): field_4 = block.timestamp + 0x015180 (1 day)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be rotated or that accepts ERC-1271 signatures. Creators of existing envelopes recover their funds with finalWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
