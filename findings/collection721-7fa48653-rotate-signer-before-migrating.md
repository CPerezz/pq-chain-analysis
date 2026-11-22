---
id: collection721-7fa48653-rotate-signer-before-migrating
title: "Collection721: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7fa48653e19b91b6e4027fc275011c31820a1964"
  family: "9866ef2d89351d30adaf62e203e55479"
  copies: 3
  name: "Collection721"
  label: "DragonFishTokyoSpaceWar: DFTSW Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 318
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16
  last_active: 2026-10-29
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`Collection721` at `0x7fa48653e19b91b6e4027fc275011c31820a1964` (Etherscan tag: DragonFishTokyoSpaceWar: DFTSW Token), with 2 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateSaleConfigRoot). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- Reviewed through the root issue's mechanism: the reading for this address names a function that replaces the checked key (a setter, a role grant or an owner hand-over), so its holder can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $318 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 16 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
