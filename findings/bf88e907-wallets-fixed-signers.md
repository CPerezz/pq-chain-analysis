---
id: bf88e907-wallets-fixed-signers
title: "0xbf88e907: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbf88e90783d1049acae742b181af3ebce0faef33"
  family: "cde8a592884a8b48d1442cb5cd9674e0"
  copies: 242
  upgradeable: "no"
  rating: HIGH
  value_usd: 1361
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
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
  rating: HIGH
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $1361, txs_90d 0; value does not lower the rating."
---

## Summary

SimpleMultiSig-style ETH wallet (execute with executor/gasLimit, Withdrawal event): `threshold` ecrecovered owners from the isOwner mapping, fixed at deployment.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 242 multisig wallets with ordered owner signatures and no way to change owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Runtime differs from the dossier code.hex, but the selectors (execute, nonce, ownersArr, threshold) and the decompiled logic (ecrecover loop → isOwner) match the family
- SSTORE scan: only the nonce (slot 0) is written at runtime; no owner setter, no proxy, no DELEGATECALL/SELFDESTRUCT
- At 26438999: threshold 2, nonce 0, owners 0x219657Cd…, 0x229A1a7E…, 0x8A229863…, all EOAs n0

## Impact and exposure

- Value held at block 26,438,999: $1,361 (ETH and 49 priced tokens, over 242 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
