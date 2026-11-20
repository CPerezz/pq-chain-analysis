---
id: 698a5448-fixed-signer
title: "0x698a5448: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x698a54483e82e22d031ad408ad93a68727f925a6"
  family: "fb4b02500d1ebaaab038041c010f9062"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new contract with a new signer, and off-chain systems switch to it."
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
  note: "The decompiled tail of purchase (the unconditional reverts) is a heimdall artifact. The flow is still clear: verify the signature, mark the offer ID as used, then pay. The owner is currently the same address as the signer, but the owner variable is not used in the signer check."
---

## Summary

purchase() compares the ecrecover result with the hardcoded constant 0x51d8..., which has no code today (EOA). No function can replace the signer, and there is no upgrade path. If that account gets code, signed purchases stop. Nothing is locked, because the contract only passes ETH through.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- purchase: require(0x51d87492c2fef5a0edf6e23208d9a02c61b0d08b == address(var_o), "bad-signer")
- Verified facts: 0x51d8... is an EOA (no code) and not 7702-delegated
- transferOwnership/renounceOwnership write only store_d/owner at slot 0, and setFee writes only feep at slot 2
- purchase forwards msg.value with payable(arg1).transfer and fee transfer to 0x51d8... in the same tx; no withdraw function, so no balance is held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be changed by an admin, or that accepts ERC-1271 signatures, and move off-chain signing to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
