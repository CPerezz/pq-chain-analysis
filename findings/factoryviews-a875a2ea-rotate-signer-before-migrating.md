---
id: factoryviews-a875a2ea-rotate-signer-before-migrating
title: "FactoryViews: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa875a2ea052454886530919b78270d81e2532966"
  family: "41a78f5ec2c6f34aa401e5c2def7c22b"
  copies: 2
  name: "FactoryViews"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 51
  last_active: 2026-10-05
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
evidence:
  level: source-read
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

`FactoryViews` at `0xa875a2ea052454886530919b78270d81e2532966`, with 1 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template ad8cefc3: migrateWithSig (read whole): called by the owner with the staker's signature, checked by SignatureChecker (ECDSA or the staker's ERC-1271) / SignatureChecker on a signer…. Template.
- Reviewed through the root issue's mechanism (D-025): the owner is the checked signer, and this address's code holds transferOwnership, so the owner hands over before its key takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 51 transactions called it in the 90 days before that block; last on 2026-10-05.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
