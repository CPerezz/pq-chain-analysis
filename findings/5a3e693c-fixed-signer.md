---
id: 5a3e693c-fixed-signer
title: "0x5a3e693c: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5a3e693c71381dea248b9fc6cbcad4a6de32aefb"
  family: "4d421fb2f127793ea6f7054c909917fb"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner (0xecbd1847cff593f8d1b6e020ff422f4b88c1c50e) withdraws funds and redeploys or pays buyers manually"
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
  note: "The deposit and claim functions are not resolved in the decompilation (Unresolved_963084a0 only shows revert()). Their signature gating is taken from the study note (template 80af2596)."
---

## Summary

The signer is a constant in the bytecode and has no code today. No function can replace it. If the signer key's account gets real code, signed deposits and claims stop. The owner's withdraw can still move every token and ETH held, so nothing is permanently locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `signer` is declared as a public constant: 210216663088442616138798481923599409834926400585.
- The getter signer() returns 0x24d270f1c5df75571d301be39160ae146bd5e449; the verified facts show this address has no code.
- Only setter: transferOwnership writes store_c (the owner), not the signer.
- withdraw(address,address,uint256) is require(owner == msg.sender): it transfers any ERC20 (0xa9059cbb) or ETH.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner withdraws the sale tokens and ETH, then distributes them to buyers or redeploys with a signer that can be replaced or with ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
