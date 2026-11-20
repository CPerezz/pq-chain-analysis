---
id: 8b283342-rotate-signer-before-migrating
title: "0x8b283342: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8b2833425d751c1fbfb5c6d43d209ff9b366439e"
  family: "e40e4882dda28fdc8499fb5798d87636"
  upgradeable: "no"
  rating: LOW
  value_usd: 47640
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 47829
  last_active: 2026-11-18
  recoveries_14d: 2753
fix:
  layer: onchain-config
  who_acts: "admin 0x8687b08b (EOA)"
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
  note: "Setter exists and the admin is a live EOA."
---

## Summary

Vault/router (47,829 txs in 90 days) whose signed transfers need a key from a stored signer set. A signer with code makes those transactions revert (replayed by the study).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addSigner, removeSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Decompile: addSigner/removeSigner require msg.sender == store_a (admin)
- admin() at block 26438999 = 0x8687b08b3db0bbedca02d8c6a4c28aa5094393ad, no code, nonce 120
- The contract has its own 1271 function (0x1626ba7e) for its own signatures, but signer recovery itself is ECDSA-only

## Impact and exposure

- Value held at block 26,438,999: $47,640 (ETH and 49 priced tokens).
- Activity: 47,829 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,753 signature recoveries in the study's two-week trace window.

## Remediation

Admin adds an EOA signer with addSigner and removes the old one with removeSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
