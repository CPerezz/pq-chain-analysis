---
id: mevwalletv1-8608a089-rotate-signer-before-migrating
title: "MevWalletV1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8608a089a9ec9a5483faa12a56e987901aad27ce"
  family: "4e559de50b0c624c6d2f2cbc523b90c8"
  copies: 2
  name: "MevWalletV1"
  upgradeable: "no"
  rating: LOW
  value_usd: 9023
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0xee8AE1F1…5eaB (EOA)"
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
  note: "Owner-held setter (key holder itself), live EOA."
---

## Summary

MevWalletV1 clone: meta-transactions must be ecrecover-signed by the owner. If the owner takes code, meta-txs fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner of the contract. Read from source.
- MevWalletV1.sol:102-106 signer must equal owner
- transferOwnership is onlyOwner, which accepts msg.sender == owner
- address(this) (lines 62-65, 72); the owner can also call directly
- owner() = 0xee8AE1F1B4B1E1956C8Bda27eeBCE54Cf0bb5eaB, no code, nonce 66

## Impact and exposure

- Value held at block 26,438,999: $9,023 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner transfers ownership to a key without code, or calls the wallet directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
