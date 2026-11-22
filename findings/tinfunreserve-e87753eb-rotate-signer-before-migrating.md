---
id: tinfunreserve-e87753eb-rotate-signer-before-migrating
title: "TinfunReserve: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe87753eb91d6a61ea342bb9044a97764366cc7b2"
  family: "4cb5058003dc9de76480e59b6a0c4ea1"
  copies: 2
  name: "TinfunReserve"
  upgradeable: "yes"
  rating: LOW
  value_usd: 162771
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner Safe"
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
  note: "setter exists, live Safe owner"
---

## Summary

TinfunReserve (proxy) checks proofs against stored signer/guardian; a signer with code fails recovery.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- setSigner/setGuardian are onlyOwner (src/TinfunReserve.sol:174,218)
- owner 0x6650dc11… is a Safe, 2 of 3 owners (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $162,771 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owner sets a new signer/guardian EOA

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
