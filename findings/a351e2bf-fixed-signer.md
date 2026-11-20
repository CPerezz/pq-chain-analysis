---
id: a351e2bf-fixed-signer
title: "0xa351e2bf (tagged deployed by CIAN: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa351e2bf070f3d95bc51e8cff7b14f25a812b45f"
  family: "1f9b3f46a88c82707449b585550fbc96"
  label: "deployed by CIAN: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The strategy owner or the vault would have to deploy a new implementation with an updated RedStone signer set and switch to it (setVault, or a proxy upgrade)."
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
  note: "The study note calls this a presale; that is wrong. It is a RedStone-consuming strategy implementation. The withdraw path was judged from decompiled code that may be incomplete, which is why the rating is MEDIUM rather than HIGH."
---

## Summary

The RedStone signer set (5 constant addresses) is fixed in the bytecode, and all 5 have no code today. If enough of these keys get real code, the price-signed rebalance functions stop working. The vault-only withdraw path does not appear to need signed prices, so this is a liveness problem, not a lock of funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: implementationAddress(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- getAuthorisedSignerIndex compares the recovered address to 5 hardcoded addresses and is a pure function
- getUniqueSignersThreshold = 3 (constant)
- The string constant 'redstone-primary-prod' shows this is the RedStone primary data service
- Verified facts: all 5 signer addresses are EOAs with no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new strategy implementation that reads the authorised signers from updatable storage or uses a newer RedStone consumer. Then point the vaults or proxies at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
