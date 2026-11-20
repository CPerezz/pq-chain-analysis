---
id: 5d01a5b5-fixed-signer
title: "0x5d01a5b5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d01a5b57494df6d1c51fe1b9b1f5b00f9ac21b4"
  family: "215315de1f2bc3adced7a473cb93b980"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (burn/claim liveness only)"
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
  note: "No update path; no withdraw exit exists but that predates EIP-8151 — the defect's own effect is the gated function reverting (liveness), not a new lock."
---

## Summary

A 'GrokBox' capsule/burn-tracking NFT contract (`burnTxTotal`, `burnTxUsed`, `totalGrokBurned`, `isCapsuleOpen`) whose byte-minting or capsule-opening path is gated by a signature; EIP-8151 breaks that gate once the signer's address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- disassembly confirms a generic ECDSA-recover helper (`PUSH1 0x01; GAS; STATICCALL` at pc 0031f5, then masking the 20-byte result and branching on `== 0`), the standard `tryRecover` shape, called from elsewhere in the bytecode
- heimdall could not reconstruct the caller that compares the recovered address to a literal signer constant; the exact signer value could not be isolated
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> no way to rotate the signer
- facts.exits = [safeTransferFrom x2, transferFrom, transferOwnership]: no withdraw/sweep function found, a pre-existing custody gap independent of EIP-8151 (the gated call simply reverts, collecting nothing new, once the defect triggers)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
