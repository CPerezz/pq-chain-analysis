---
id: priceattestorv3-0e6ff904-rotate-signer-before-migrating
title: "PriceAttestorV3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0e6ff904f764c0b5b84a9c3c1780e08dff84deb9"
  family: "69098ed00dff5a2e22ab5e8c0ceca734"
  name: "PriceAttestorV3"
  upgradeable: "no"
  rating: LOW
  txs_90d: 139
  last_active: 2026-11-12
  recoveries_14d: 107
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
evidence:
  level: executed
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

`PriceAttestorV3` at `0x0e6ff904f764c0b5b84a9c3c1780e08dff84deb9`. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: PriceAttestor _evaluate: the snapshot must be signed by `signer` (text cut; signer replaced by proposeSigner and acceptSigner, by name) / PriceAttestor._recover: returns the signer /…. Read from source. Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism (D-025): the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 139 transactions called it in the 90 days before that block; last on 2026-11-12.
- 107 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
