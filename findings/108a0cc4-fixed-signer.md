---
id: 108a0cc4-fixed-signer
title: "0x108a0cc4 (tagged deployed by CIAN: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x108a0cc4f56f8b9bb3a3db96bb88b7a8185fc749"
  family: "547d0c749d14de4cdeb372c91e51555a"
  label: "deployed by CIAN: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The strategy owner or the vault/proxy admin, who would deploy a new implementation with new signers. RedStone controls the signer keys."
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
  note: "The study note calls this a presale with signed deposit and claim. That is wrong: this is a RedStone-oracle strategy implementation. I rated it MEDIUM on the assumption that the vault-only withdraw(uint256) can still move funds out without a signature. The vault contract was not given, so I could not check whether its user withdrawals also need the oracle net-asset price. If they do, deposited funds could be stuck and the rating would be higher."
---

## Summary

The five RedStone signer addresses are hard-coded constants with no setter, no code check and no ERC-1271 fallback. All five have no code today. If enough of these signer accounts got real code, the oracle-gated functions (rebalancing and net-asset pricing) would stop. The vault's withdraw(uint256) path does not need a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: implementationAddress(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- getAuthorisedSignerIndex: a chain of literal comparisons against 0x8bb8f32d…, 0xdeb22f54…, 0x51ce04be…, 0xdd682dae…, 0x9c5ae89c…. Any other address reverts with CustomError_ec459bc0.
- getUniqueSignersThreshold = 3; getDataServiceId = 'redstone-primary-prod'
- Verified facts: all 5 signer addresses are EOAs with no code at block 26438999
- No function writes a signer; the only state the owner can set is vault, rebalancer, flashloanHelper, feeReceiver, safeRatio, revenueRate and owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new strategy implementation whose RedStone signer set can be updated or that checks signers with ERC-1271, then point the proxy or vault at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
