---
id: 52d4557a-fixed-signer
title: "0x52d4557a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x52d4557a43a1f5b82ffee10b220e764eb7da1784"
  family: "6c1a623a5b20fd76d44c137264cdd5af"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-13
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
  note: "No update path; no withdraw exit exists but that is a pre-existing flaw of this specific contract, not something EIP-8151 causes — the defect's own effect is mint reverting (liveness), not a new lock."
---

## Summary

NFT/token launchpad mint gated by an EIP-712 voucher: the contract recovers the signer with ecrecover and reverts the mint unless it equals a hardcoded address; EIP-8151 makes every such mint revert once that address ever gets code (7702 or a contract).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Function surface matches the template idiom (mintApe/ownerMint/publicMint-style payable mint, ERC721 transfer surface, renounce/transferOwnership only)
- heimdall's reconstruction of the signature-checking mint function is garbled (same failure mode as the verified template); exact signer constant not isolated
- facts.setters = [transferOwnership] only; facts.upgrades = []
- facts.exits = ['safeTransferFrom(address,address,uint256)', 'safeTransferFrom(address,address,uint256,bytes)', 'transferFrom(address,address,uint256)', 'transferOwnership(address)']: no owner withdraw/sweep function found at all — a pre-existing custody gap, not one newly created by EIP-8151 (mint simply reverts once the defect triggers, collecting nothing further)

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
