---
id: 1a6a47f4-rotate-signer-before-migrating
title: "0x1a6a47f4: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1a6a47f4080eaa48ee66aaa8893c3ae9edd0553d"
  family: "8f2684d99f98f93cf194dc70923ee959"
  upgradeable: "no"
  rating: LOW
  value_usd: 13715
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1623
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner Safe 0xd00e1c6db37f9ca21bd209681d193c6cea2b6ed2 (2 of 3)"
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
  note: "LOW: setter callable by a live 2-of-3 Safe."
---

## Summary

Unverified contract with a stored signer (slot 4) checked by ecrecover (eq_storage). setSigner and setOperator replace the key.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setOperator, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: signer at slot 4; setOperator/setSigner/transferOwnership require msg.sender == owner (slot 0)
- owner = Safe 0xd00e…: getOwners = [0x5Cb358…(nonce 71), 0xE5246c…, 0x5A85CE…], getThreshold = 2 at block 26438999
- signer() = 0 at the block, so the signed path is currently unset

## Impact and exposure

- Value held at block 26,438,999: $13,715 (ETH and 49 priced tokens).
- Activity: 1,623 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The owner Safe calls setSigner/setOperator with a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
