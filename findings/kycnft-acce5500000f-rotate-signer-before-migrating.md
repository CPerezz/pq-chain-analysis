---
id: kycnft-acce5500000f-rotate-signer-before-migrating
title: "KycNFT: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xacce5500000f71a32b5e5514d1577e14b7aacc4a"
  family: "bc2e62d54905c18278b8290228b75df3"
  copies: 3
  name: "KycNFT"
  upgradeable: "no"
  rating: LOW
  txs_90d: 366118
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner 0x89c8…7da3"
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
  note: "the owner is the signer and can hand the role over; live EOA"
---

## Summary

KycNFT: mint needs a signature from owner(); an owner with code fails recovery.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- KycNFT.sol:38 checks owner() == ECDSA.recover(hash, signature); transferOwnership is OZ Ownable (verified source)
- owner() = 0x89c8eec57bd474816d407fe38354b8410b567da3 at block 26438999; EOA, nonce 939

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 366,118 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

owner transfers ownership to a fresh EOA before taking code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
