---
id: d3599822-fixed-signer
title: "0xd3599822: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd359982282fafea404def6ef5216ca4503f3c8b2"
  family: "5bfdf27714b3978906e44a1f2473e95a"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (new-purchase liveness only)"
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
  note: "New purchases stop (revert, nothing collected) but pre-existing claims[msg.sender] stay payable via claim() which has no signature gate, so no funds already owed are locked."
---

## Summary

A presale/purchase contract: `purchaseTokenWithToken(...)` takes payment and records `claims[msg.sender]` only if a packed (v, r, s) signature recovers to a fixed signer; a separate `claim()` later pays out based on that flag with no signature check of its own. EIP-8151 stops new purchases once the signer's address gets code; purchases already recorded are unaffected.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source of `claim()` (decompiled.sol) shows no ecrecover call: it only checks `claims[msg.sender]` and `storage_map_f[msg.sender]`, then transfers out — so already-allocated claims stay payable even if the signer later breaks
- stack-traced disassembly confirms two STATICCALL-to-address(1) sites, inside `purchaseTokenWithToken`/`Unresolved_99790d78`-style functions that take `uint8,bytes32,bytes32`-shaped trailing args (v, r, s)
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> no way to rotate the purchase-authorization signer
- `purchaseTokenWithToken` reverts if the signature check fails, so a buyer's payment is never taken (no funds lost on the failing path) once the defect triggers

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix for the hardcoded signer; redeploy with a replaceable signer before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
