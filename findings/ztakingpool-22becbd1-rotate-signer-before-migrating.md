---
id: ztakingpool-22becbd1-rotate-signer-before-migrating
title: "ZtakingPool: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x22becbd1958d25536b7a08bbc12e6048df4ab9a3"
  family: "ad8cefc31a84fa532a5c8ff8d49d5720"
  copies: 3
  name: "ZtakingPool"
  label: "Zircuit: Restaking Pool"
  upgradeable: "no"
  rating: NONE
  value_usd: 35197943
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1454
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "pool owner"
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
  verdict: refuted
  rating: NONE
  note: "ERC-1271 for the same signer means refuted. If counted as a finding, LOW: owner EOA 0x9567 is live (nonce 50)."
---

## Summary

Zircuit ZtakingPool. migrate/migrateWithSig check zircuitSigner and the staker through OZ SignatureChecker (ECDSA, then ERC-1271).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: migrateWithSig (read whole): called by the owner with the staker's signature, checked by SignatureChecker (ECDSA or the staker's ERC-1271) / SignatureChecker on a signer kept in storage (ECDSA, or…. Read from source.
- reading ad8cefc3: SignatureChecker on the stored zircuitSigner and on the staker
- setter setZircuitSigner onlyOwner; owner() at block = 0x9567c40d... (EOA, nonce 50)
- withdraw() does not use the recovery

## Impact and exposure

- Value held at block 26,438,999: $35.2M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,454 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls setZircuitSigner, or the signer's code implements ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
