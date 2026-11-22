---
id: 31a53ce4-rotate-signer-before-migrating
title: "0x31a53ce4: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x31a53ce49c99b0c05085dd76d17669871dacd6c0"
  family: "06d3918388a179d5f0ad732210be0f40"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1840
  last_active: 2026-11-18
  recoveries_14d: 67
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x9a16…7362"
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
  note: "Setter exists, plus an upgrade path, both held by a live Safe, so LOW holds."
---

## Summary

An upgradeable ERC-721 with a migration claim signed by a stored migrationSigner. Claims fail once that signer's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setMigrationSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- EIP-1967 implementation = 0x3bdfe8e35e6c879ada528c707e02d28d2728a67a; its setMigrationSigner(address) requires owner == msg.sender (OZ 0x118cdaa7) (decompile)
- UUPS upgradeToAndCall is also present (facts.upgrades)
- owner() = Safe 0x9a16…7362, 3-of-5, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,840 transactions called it in the 90 days before that block; last on 2026-11-18.
- 67 signature recoveries in the study's two-week trace window.

## Remediation

The owner Safe calls setMigrationSigner (or upgrades).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
