---
id: 35ac13ef-rotate-signer-before-migrating
title: "0x35ac13ef: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x35ac13efaab970f32269b61e4704f4377ce7a0ad"
  family: "a26ec3fd1e90fe0259eec37d5bc3cdf3"
  copies: 4
  upgradeable: "yes"
  rating: LOW
  value_usd: 20211
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2254
  last_active: 2026-11-17
  recoveries_14d: 541
fix:
  layer: onchain-config
  who_acts: "owner"
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
  note: "There is a setter and a live owner. The dossier facts carry the sender-gas-limits entry, but this row's root is rotate-signer. 2,254 txs in 90d."
---

## Summary

Unverified TaskOn fund proxy (impl 0x97ed…433a): withdrawals are signed by keys in a signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addSigner, updateSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- decompiled impl: addSigner/deleteSigner require msg.sender == owner (Ownable)
- owner 0x8ee6…265 is a 7702-delegated EOA (0xef0100…), nonce 8, still able to transact

## Impact and exposure

- Value held at block 26,438,999: $20,211 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 2,254 transactions called it in the 90 days before that block; last on 2026-11-17.
- 541 signature recoveries in the study's two-week trace window.

## Remediation

Owner deletes a migrating signer and adds a key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
