---
id: entrylogic-2ef5513e-signer-upgrade-only
title: "EntryLogic: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d"
  family: "4ccd8b345d2dcbbaea1cfccf0d05342b"
  name: "EntryLogic"
  upgradeable: "yes"
  admin: "0x9c968a4007979040a2c3dbcdbc8e78bb2d0a4ad2"
  rating: LOW
  txs_90d: 903
  last_active: 2026-11-13
  recoveries_14d: 209
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x90d4d7753a5d7d623f25927b4d30ff34b9246551, admin 0x9c968a4007979040a2c3dbcdbc8e78bb2d0a4ad2)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
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

`EntryLogic` at `0x2ef5513ed9c44ddff9ff10b5120426cabd27c49d`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: bridge fee quote: the signer must be feeSigner. Read from source.
- Update path, read at block 26,438,999: proxy to 0x90d4d7753a5d7d623f25927b4d30ff34b9246551, admin 0x9c968a4007979040a2c3dbcdbc8e78bb2d0a4ad2.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 903 transactions called it in the 90 days before that block; last on 2026-11-13.
- 209 signature recoveries in the study's two-week trace window.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
