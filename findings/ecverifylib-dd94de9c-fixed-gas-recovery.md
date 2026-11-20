---
id: ecverifylib-dd94de9c-fixed-gas-recovery
title: "ECVerifyLib: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xdd94de9cfe063577051a5eb7465d08317d8808b6"
  family: "c045c1e1c369418b5e521882db9c1273"
  copies: 2
  name: "ECVerifyLib"
  label: "devcon two: EC Verify Lib"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "token deployer"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "only the mint-by-signature function stops; nothing is locked and no ETH is held"
---

## Summary

Old (solc 0.4) token/registry with ownerOf(bytes32)/tokenId(address); function 0x216ef940 mints an ID for an address only after ECVerifyLib.ecverify(0x39cdde32) at 0x9e475f8b...505 confirms that address signed. The library forwards 3000 gas to 0x01, so every mint by signature returns false after activation.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: delegates to a fixed address.
- ECVerifyLib.sol safer_ecrecover: `ret := call(3000, 1, 0, size, 128, size, 32)`; ecverify returns `ret == true && addr == signer`
- dd94 bytecode embeds library 0x9e475f8b49be49daf0571a53dda0fc9bfdbcf505 and calls selector 0x39cdde32 once, inside 0x216ef940; on success it sets storage_map_c/b, store_d += 1, emits Mint, else returns false
- balance 0; totalSupply() = 231 at block 26438999; txs_90d 0
- the library address is hard-coded in the bytecode; no proxy slots

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract (or library) that uses the native ecrecover with no gas cap.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
