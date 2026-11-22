---
id: olinxmessageverifier-31d4753d-rotate-signer-before-migrating
title: "OLinxMessageVerifier: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0"
  family: "890610ee4ce3d3e85aa7aeab3bf629b7"
  copies: 5
  name: "OLinxMessageVerifier"
  upgradeable: "no"
  rating: LOW
  txs_90d: 10
  last_active: 2026-11-17
  recoveries_14d: 7
fix:
  layer: onchain-config
  who_acts: "the key holder or owner rotates the key"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`OLinxMessageVerifier` at `0x31d4753dec2a62d2c18ff4ae1d20ad039e3fc4c0`, with 4 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (attester, validator, signer, author), ordered or counted once; a threshold is needed. Read from source.
- Reviewed through the root issue's mechanism: the checked signers are a committee or validator set that its own quorum replaces by a signed update, so while enough keys are still EOAs the set rotates before migrating: LOW, as for wallets their own signers can upgrade
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-17.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
