---
id: invoice-52174932-rotate-signer-before-migrating
title: "Invoice: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5217493257fcbf209580342e6929e20d2ac914f1"
  family: "d217865e3f6cd96c64500a7c4ea51492"
  name: "Invoice"
  upgradeable: "no"
  rating: LOW
  value_usd: 27249
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6243
  last_active: 2026-11-18
  recoveries_14d: 833
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x891a…de08"
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
  note: "Live EOA admin replaces the key."
---

## Summary

Invoice payment contract: pay() requires a quote signed by quoteSigner (0xa97C…922F, nonce 0).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setSigner(address) is isAdmin (msg.sender == owner) (Invoice.sol:115)
- owner() = 0x891a…de08, EOA nonce 612 at 26438999
- Owner also holds withdraw()

## Impact and exposure

- Value held at block 26,438,999: $27,249 (ETH and 49 priced tokens).
- Activity: 6,243 transactions called it in the 90 days before that block; last on 2026-11-18.
- 833 signature recoveries in the study's two-week trace window.

## Remediation

Owner calls setSigner(newKey) before the quote key migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
