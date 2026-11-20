---
id: nxv-d19d8ee0-rotate-signer-before-migrating
title: "NXV: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd19d8ee0a736bf643f53e3dc5489ac94e947a482"
  family: "e41c77f855610a70e75dafea9fe77662"
  copies: 80
  name: "NXV"
  upgradeable: "yes"
  rating: LOW
  value_usd: 12187637
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 576
  last_active: 2026-11-18
  recoveries_14d: 95
fix:
  layer: onchain-config
  who_acts: "NXV owners (3 of 7)"
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
  note: "LOW holds only if rotation happens before migrating; the reading itself flags MEDIUM/HIGH after migration. Reviewer attention."
---

## Summary

NXV, a Safe fork. Owners sign by ECDSA only, with no contract-signature or approveHash path.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: NXV (a Safe fork): requiredSignatures owners in ascending order, by ECDSA only: no contract-signature and no approved-hash branch. Read from source.
- getOwners() = 7 addresses, getThreshold() = 3 at the block; all 7 owners are code-less (nonce 0, off-chain signers)
- reading e41c77f8: owner replacement needs threshold ECDSA signatures; locks if more than ownerCount - threshold migrate without rotating

## Impact and exposure

- Value held at block 26,438,999: $12.2M (ETH and 49 priced tokens, over 80 addresses).
- Activity: 576 transactions called it in the 90 days before that block; last on 2026-11-18.
- 95 signature recoveries in the study's two-week trace window.

## Remediation

Owners rotate keys through a threshold-signed owner change before any owner key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
