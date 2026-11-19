---
id: d9b20cfe-wallets-fixed-signers
title: "0xd9b20cfe: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd9b20cfed69e76acae3fa1c2ee1faafafcb41f55"
  family: "45ff45a3e933966c3196581aa34c515f"
  copies: 6
  upgradeable: "no"
  rating: HIGH
  value_usd: 27294
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owners move funds before their signers take code"
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
  note: "owners fixed"
---

## Summary

Contract `0xd9b20cfed69e76acae3fa1c2ee1faafafcb41f55`, with 5 more addresses running its code. A wallet whose signers are fixed in code; once enough of them take code, it can no longer move anything.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: four selectors: a multisig with ordered owner signatures and no way to change owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: four selectors, ordered owner signatures, no way to change owners; threshold 3; no proxy, no upgrade.
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $27,294 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
