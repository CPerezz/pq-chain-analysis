---
id: c8d9b805-wallets-fixed-signers
title: "0xc8d9b805: wallet with signers fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc8d9b8052b59c8f0f496b3c2e1403ca441192d73"
  family: "b507d8646057e2eefa82a72ceda7ff2a"
  copies: 5
  upgradeable: "no"
  rating: LOW
  txs_90d: 328
  last_active: 2026-11-11
  recoveries_14d: 44
fix:
  layer: onchain-config
  who_acts: "the owners (threshold 2 of 5), through a signed execute to the wallet itself"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a setter replaces the key. Not simulated: an execute whose destination is the wallet itself (needs owner signatures); the setter gate and the OwnersChanged event show it is designed for that."
---

## Summary

SimpleMultiSig-style wallet with setOwners(uint256,address[]), callable only by the wallet itself (msg.sender == address(this)), so the owners replace the signer set through a signed execute.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: multisig with ordered owner signatures; no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors include setOwners(uint256,address[]) f3182e85 and execute a0ab9653; the decompiled setOwners requires address(this)==msg.sender, rewrites ownersArr/isOwner/threshold and emits OwnersChanged
- threshold 2, ownersArr = 5 EOAs (latest); balance 0 per row (value_usd null)
- Signers 0x812B6E69bb119DaDfbd51e205Ef80fb04757349B, 0x90249b71c9e30d4825079c1Ed7eE5c0dC479c869, 0xBd5ad37A292D902B083F80534d3D3581c23B3F1b, 0xCce0D0939f0412a5050401092A9BAC704B9A20B5, 0xF455A0DD89C775D0B77B8cde94C4Dc329a1c5Da0: all EOAs (latest, block ~26452917)
- value_usd None, txs_90d 328, last_active 2026-11-11 (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 328 transactions called it in the 90 days before that block; last on 2026-11-11.
- 44 signature recoveries in the study's two-week trace window.

## Remediation

Owners sign an execute targeting the wallet with setOwners(...) to swap any key that will get code, before that key migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
