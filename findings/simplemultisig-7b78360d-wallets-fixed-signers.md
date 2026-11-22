---
id: simplemultisig-7b78360d-wallets-fixed-signers
title: "SimpleMultiSig: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x7b78360df65b279d41b069f014828b747b51bc28"
  family: "96531cc93dd2ae92116c69c87bc418f0"
  copies: 8
  name: "SimpleMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 850
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
evidence:
  level: source-read
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
  rating: HIGH
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $850, txs_90d 0; value does not lower the rating."
---

## Summary

SimpleMultiSig (execute with executor/gasLimit, no setOwners): `threshold` ecrecovered owners, fixed at deployment.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig execute: threshold owners, set at deployment; no function changes them. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Runtime identical to the dossier code.hex (gate1 source SimpleMultiSig.sol); selectors execute, nonce, ownersArr, threshold; no setOwners
- SSTORE scan: only the nonce (slot 0) is written at runtime; no owner setter, no proxy, no DELEGATECALL/SELFDESTRUCT
- At 26438999: threshold 2, nonce 0, owners 0x5bCC3ca0…, 0xae161677…, 0xB7463F18…, all EOAs n0

## Impact and exposure

- Value held at block 26,438,999: $850 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
