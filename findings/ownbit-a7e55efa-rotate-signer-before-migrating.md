---
id: ownbit-a7e55efa-rotate-signer-before-migrating
title: "OwnbitMultiSigImplementation: signer key to rotate before its account takes code"
project: ownbit
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa7e55efa7177699544a11adc6c51b846c3bdc48f"
  family: "a4064f898bf43deed57e3270131c5ffc"
  copies: 9
  name: "OwnbitMultiSigImplementation"
  upgradeable: "no"
  rating: LOW
  value_usd: 4511
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 139
  last_active: 2026-11-17
  recoveries_14d: 31
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

`OwnbitMultiSigImplementation` at `0xa7e55efa7177699544a11adc6c51b846c3bdc48f`, with 8 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ownbit weighted multisig: distinct signers of the set, weights summed; signers are changed by a call the owners sign / Ownbit weighted multisig: distinct owners counted, for changing owners or signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism (D-025): the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $4,511 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 139 transactions called it in the 90 days before that block; last on 2026-11-17.
- 31 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
