---
id: 5eb71e5a-wallets-fixed-signers
title: "0x5eb71e5a: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5eb71e5a34ec8d41f6ef487e5a61138800b02436"
  family: "fc27d1aa469a146f215018344cfc016e"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owners"
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
  note: "Fixed owners; signed spend is the only exit: HIGH."
---

## Summary

The same 3-of-3 Ownbit-style spend wallet as 0x01229270 (5159 bytes, the same selectors, bytes differ slightly). Owners fixed, spend is the only exit.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher identical to 0x01229270; one SSTORE (nonce)
- Fork trace: spend reaches ecrecover 3 times with 3 signatures
- getOwners at block 26438999: 0xa11d..911c, 0x8737..45d4, 0x30d7..38fa; required 3; all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet before any key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
