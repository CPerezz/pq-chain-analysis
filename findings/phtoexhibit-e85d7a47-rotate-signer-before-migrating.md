---
id: phtoexhibit-e85d7a47-rotate-signer-before-migrating
title: "PhtoExhibit: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe85d7a471d1dbcd0403cd305c88b3a89aa9654a8"
  family: "b65997efec0b8da0055ba9f3577975b4"
  name: "PhtoExhibit"
  upgradeable: "no"
  rating: LOW
  txs_90d: 11
  last_active: 2026-10-13
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`PhtoExhibit` at `0xe85d7a471d1dbcd0403cd305c88b3a89aa9654a8`. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template 5f48faed: Apollox treasury: claims are signed by a stored key that the owner replaces (_changeTruthHolder, _setOperator). Template.
- Reviewed through the root issue's mechanism (D-025): the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 11 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
