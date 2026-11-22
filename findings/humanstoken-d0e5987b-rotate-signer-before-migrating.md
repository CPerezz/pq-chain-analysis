---
id: humanstoken-d0e5987b-rotate-signer-before-migrating
title: "HumansToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd0e5987b2851f676ba2f680f8ed6a1f2ed3ba992"
  family: "796cb70c90f6e0c8ad39e26a5f72269c"
  name: "HumansToken"
  upgradeable: "no"
  rating: LOW
  txs_90d: 67
  last_active: 2026-11-17
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

`HumansToken` at `0xd0e5987b2851f676ba2f680f8ed6a1f2ed3ba992`. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template 769c238a: SignatureChecker on a signer kept in storage (ECDSA, or its ERC-1271 if it is a contract). Template.
- Reviewed through the root issue's mechanism: the reading for this address names a function that replaces the checked key (a setter, a role grant or an owner hand-over), so its holder can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 67 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
