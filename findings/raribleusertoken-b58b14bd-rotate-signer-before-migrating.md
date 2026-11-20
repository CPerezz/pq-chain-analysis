---
id: raribleusertoken-b58b14bd-rotate-signer-before-migrating
title: "RaribleUserToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb58b14bdefaf3cea66407e9ed15bb74c60aebefb"
  family: "793b4fe62f054cc8bb4c3434759b9352"
  copies: 2803
  name: "RaribleUserToken"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4734
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner"
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
  note: "Setter callable by a live EOA owner."
---

## Summary

RaribleUserToken (ERC-1155); mints need a signature from a stored signer. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- RaribleUserToken.sol: addSigner/removeSigner onlyOwner
- owner() = 0x9Da88337…; owner is an EOA (no code, nonce 11) at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 2,803 addresses).
- Activity: 4,734 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Owner adds a new signer and removes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
