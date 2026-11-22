---
id: b6071602-wallets-fixed-signers
title: "0xb6071602: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb607160241819210ba61f71300d52d4b8f57951e"
  family: "6499bc4151cbc8e0ba9193946218d35c"
  upgradeable: "no"
  rating: HIGH
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owner"
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
  note: "No setter or upgrade; a signed spend is the only exit: HIGH."
---

## Summary

The same design as 0xcfa5259e (bytecode differs slightly): a 1-of-1 spend wallet plus an owner-only token pull-in 0x354d728d. Only spend (ecrecover) moves funds out.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- One SSTORE in runtime code (nonce); no owner setter
- Fork trace: 0x354d728d is owner-only and calls allowance/balanceOf/transferFrom into the wallet ('No sufficient funds or allowance to freeze'); spend reaches ecrecover
- getOwners at block 26438999: 0x9452..c431, an EOA (cast code latest)
- No proxy slots; value $3 (fork shows about 3 USDT held), 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner signs a spend that empties the wallet before the key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
