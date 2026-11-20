---
id: pangeadvnv3-6a9f3126-rotate-signer-before-migrating
title: "PangeaDVNV3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6a9f3126c0ea3eeb9cbe53205175c9673da6565f"
  family: "50900e48b06b75749b3574878c8702ec"
  name: "PangeaDVNV3"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2317
  last_active: 2026-11-17
  recoveries_14d: 229
fix:
  layer: onchain-config
  who_acts: "admin 0x93620a4A7d45A770ff2e801eB84b03a7630ae8B6"
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
  note: "A live admin can call the setter, so a config call fixes it: LOW."
---

## Summary

PangeaDVNV3 checks signatures from a stored signer key with ecrecover; once that key's account holds code that is not a 7702 delegation, recovery returns nothing and the signed path stops until the key is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries: each signer must be in the stored set (approver, oracle, attester or author) and distinct; enough of them are needed. Read from source. Executed: a real transaction reverts with code at the signer.
- setter setSigners(address[],uint8) onlyAdmin (msg.sender == admin) in verified source (50900e48b06b75749b3574878c8702ec/source)
- admin() at block 26438999 = 0x93620a4A7d45A770ff2e801eB84b03a7630ae8B6 EOA nonce=6923
- txs_90d=2317, last_active=2026-11-17

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,317 transactions called it in the 90 days before that block; last on 2026-11-17.
- 229 signature recoveries in the study's two-week trace window.

## Remediation

Rotate the signer to a new EOA (or a key the signature check accepts) through the setter before the signing account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
