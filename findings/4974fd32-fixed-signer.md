---
id: 4974fd32-fixed-signer
title: "0x4974fd32: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4974fd321713d03c540cfb0c5e14c6d8cf5fc86d"
  family: "3bdebcec588b2e39ed928c4852356860"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (mint liveness only)"
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
  note: "No update path; mint/open just stops (nothing newly collected can get stuck because the gated calls revert); no NEW lock is introduced by EIP-8151 even though no withdraw exit was found."
---

## Summary

'KnowBox' mystery-box NFT mint with two signature-gated entry points (box mint and box-open); EIP-8151 breaks both once the signer address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile shows two ecrecover(...) calls (Unresolved_4c6cdfde and Unresolved_c17fa7a1) both with literal `require(address(var_r) == 0x9add88207ac0db396d6050716badb7ec6c96ba33, "KnowBox:Validate Sign Error")`
- `cast code` on 0x9add88207ac0db396d6050716badb7ec6c96ba33 today -> 0x (EOA), latent
- facts.setters = [transferOwnership] only, facts.upgrades = [] -> no way to rotate the signer
- facts.exits = ['safeTransferFrom(address,address,uint256)', 'safeTransferFrom(address,address,uint256,bytes)', 'transferFrom(address,address,uint256)', 'transferOwnership(address)']: no withdraw function found, but this is a pre-existing custody gap independent of EIP-8151 (mint simply reverts, collecting nothing, once the defect triggers)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
