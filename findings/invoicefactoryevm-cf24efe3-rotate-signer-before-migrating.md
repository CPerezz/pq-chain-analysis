---
id: invoicefactoryevm-cf24efe3-rotate-signer-before-migrating
title: "InvoiceFactoryEVM: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcf24efe3bad6bae085c7402c29859023c3a7844a"
  family: "397c9128525179481bcb75203adcc59b"
  copies: 2
  name: "InvoiceFactoryEVM"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 51
  last_active: 2026-11-11
  recoveries_14d: 6
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`InvoiceFactoryEVM` at `0xcf24efe3bad6bae085c7402c29859023c3a7844a`, with 1 more addresses running its code. It accepts signatures from a key that a function can replace; the holder rotates it before the account takes code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: InvoiceFactory: distinct signers holding VALIDATOR_ROLE, at least minSignatures. Read from source. Executed: a real transaction reverts with code at the signer.
- Reviewed through the root issue's mechanism: the reading for this address names how the checked key or key set is replaced (a setter, a role grant, an owner hand-over or an edit of the signer set), so it can rotate before the key's account takes code: LOW
- Not checked per row: whether the party allowed to call that function is live at block 26,438,999
- Mechanical check: the scanner finds an ecrecover call in this address's code
- A random sample of 25 of the 18,615 rows below Anon's thresholds: 15 held at LOW, 5 were unused implementations (not affected), 1 had owners that cannot be replaced (MEDIUM), 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 51 transactions called it in the 90 days before that block; last on 2026-11-11.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
