---
id: a2f5bf5e-rotate-signer-before-migrating
title: "0xa2f5bf5e: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa2f5bf5eb1b8894a514162ca7abe5f095a5371b1"
  family: "b4da8554d5fd9bcb6952869422eee5c4"
  copies: 5761
  upgradeable: "no"
  rating: LOW
  value_usd: 402056
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-13
fix:
  layer: account-migration
  who_acts: "wallet device key"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Direct-call key management and execution."
---

## Summary

Device-key wallet (5,761 copies): legacy ERC-1271 recovers a registered device; devices also act by direct call.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: device-based account (5,761 accounts, 223 ETH with tokens; Archanova-like): a signature counts when it recovers to a registered device; devices add and remove devices and also act by direct call. A…. Bytecode and names.
- add/remove devices by direct call 0x811d54dc/0x1f7b6324 from a byte-0 key (reading.keys)
- byte-0 keys execute calls directly (msg.sender)

## Impact and exposure

- Value held at block 26,438,999: $402,056 (ETH and 49 priced tokens, over 5,761 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Device adds a new EOA key; can keep acting directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
