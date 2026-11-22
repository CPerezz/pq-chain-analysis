---
id: cc6fcfb8-wallets-fixed-signers
title: "0xcc6fcfb8 (tagged LMAX Digital 2): wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcc6fcfb8b3988043e382a481d6bf482d68897024"
  family: "f1d850331dd2cfb9108f6add7bd708e4"
  copies: 40
  label: "LMAX Digital 2"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2202
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-10-21
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $2202, txs_90d 5; value does not lower the rating."
---

## Summary

SimpleMultiSig-style wallet (execute with executor/gasLimit): `threshold` ecrecovered owners from the isOwner mapping, set only at deployment.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 40 multisig wallets with ordered owner signatures and no way to change owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: recovered addresses must be in the isOwner mapping (slot 2) in ascending order; nonce++ then transfer
- SSTORE scan: only the nonce (slot 0) is written at runtime; no owner setter, no proxy, no DELEGATECALL/SELFDESTRUCT
- At 26438999: threshold 3, nonce 8874 (in active use: txs_90d 5, last 2026-10-21), 5 owners all EOAs n0

## Impact and exposure

- Value held at block 26,438,999: $2,202 (ETH and 49 priced tokens, over 40 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-10-21.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
