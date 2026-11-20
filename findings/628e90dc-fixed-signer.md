---
id: 628e90dc-fixed-signer
title: "0x628e90dc: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x628e90dc1f4b21b84df4b51402b4fce270a12746"
  family: "dcb5a3b61a89a69b0a6e347ac89edb4c"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 33
  last_active: 2026-10-14
fix:
  layer: account-migration
  who_acts: "deployer/owner (liveness only)"
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
  note: "No funds held by this contract per its decompiled function surface; the only effect of the defect is a stopped registry/oracle-validation function."
---

## Summary

A signature-revocation registry (`hashRevoke`, `isRevoked`, `revoke`) gated by a fixed signer check inside several Unresolved functions; EIP-8151 stops new revocations once that signer gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ecrecover(address 1) call confirmed present in the contract's bytecode (stack-traced disassembly) or clearly implied by the function surface (fixed signer/authoriser-index idiom)
- facts.setters = [transferOwnership] only; facts.upgrades = [] -> no way to rotate the signer
- facts.exits = ['transferOwnership(address)']: no value-transfer function found in the decompiled surface besides transferOwnership — this is a registry/oracle-consumer, not a funds-custody contract

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 33 transactions called it in the 90 days before that block; last on 2026-10-14.

## Remediation

No on-chain fix; redeploy with a replaceable signer/authoriser set before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
