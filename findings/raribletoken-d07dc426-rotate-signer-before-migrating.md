---
id: raribletoken-d07dc426-rotate-signer-before-migrating
title: "RaribleToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd07dc4262bcdbf85190c01c996b4c06a461d2430"
  family: "e383a395a6cefda53281aaea85c54947"
  name: "RaribleToken"
  upgradeable: "no"
  rating: LOW
  value_usd: 77
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1569
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner 0x5675…e9c5"
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
  note: "stored-key setter callable by a live EOA owner"
---

## Summary

RaribleToken (ERC-1155) mint gated by signatures from a stored signer set.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addSigner, removeSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- addSigner/removeSigner are onlyOwner ("Ownable: caller is not the owner") in decompile
- owner() = 0x5675ff50d5d48b87fbcfbcbfc78f15f4964fe9c5 at block 26438999; EOA, nonce 15

## Impact and exposure

- Value held at block 26,438,999: $77 (ETH and 49 priced tokens).
- Activity: 1,569 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

owner adds a fresh EOA signer and removes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
