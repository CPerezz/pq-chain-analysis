---
id: blevererc721c-0ae671a3-rotate-signer-before-migrating
title: "BleverErc721C: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0ae671a34935151c2de2e2e185d0c2dbdfe0645c"
  family: "b07d18456c8d8b2e89265b983ae08cc8"
  copies: 32
  name: "BleverErc721C"
  upgradeable: "no"
  rating: LOW
  value_usd: 14
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3029
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner 0x5f15…E7C"
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
  note: "stored-key setter callable by a live (7702-delegated) EOA owner"
---

## Summary

BleverErc721C minimal-proxy clone (impl 0x50cfd657…62c1) with a stored mint signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setAutomaticApprovalOfTransfersFromValidator, setSigner, setTransferValidator). Whoever holds it must replace it before that account takes…. Rule: stored-key.
- setSigner(address) onlyOwner in impl decompile
- owner() at the clone = 0x5f15bDcC69CA38409895d21f23665Eb084ADbE7C at block 26438999; EOA with EIP-7702 delegation (0xef0100…), nonce 799

## Impact and exposure

- Value held at block 26,438,999: $14 (ETH and 49 priced tokens, over 32 addresses).
- Activity: 3,029 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

owner calls setSigner with a fresh EOA

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
