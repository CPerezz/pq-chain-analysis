---
id: d45fb65f-fixed-signer
title: "0xd45fb65f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd45fb65f528a12b1b5997c89c7731cc42fade083"
  family: "12cb860c737c9ef370a627b9fe07bccc"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 17
  last_active: 2026-09-08
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
  note: "No funds custody found in this contract's function surface (feeVault is a separate address, not held here); impact is a stopped relay/registry function, not a lock."
---

## Summary

A relay/registry contract (`repoCurve`, constants `feeVault`/`relaySigner`) that only accepts relayed calls signed by a fixed `relaySigner`; EIP-8151 stops new relayed calls once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `uint256 public constant relaySigner = 1384379210609778659410783043937755999709627436046;` (0x735a9f1b93cb0ac4a86d38e56f99bcd1b07ddbce) and a separate `feeVault` constant
- disassembly confirms a STATICCALL with gas forwarded to address 1 inside the contract's unresolved internal-call bytecode (pc 000955), though heimdall could not render the surrounding Solidity for the comparison
- facts.setters = [] and facts.upgrades = [] per batch facts -> no way to rotate relaySigner
- facts.exits = []: empty — repoCurve() is a read-only getter, no value-transfer function found in the decompiled surface

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 17 transactions called it in the 90 days before that block; last on 2026-09-08.

## Remediation

No on-chain fix; redeploy with a replaceable relaySigner before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
