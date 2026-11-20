---
id: primerewardpool-b5db3757-rotate-signer-before-migrating
title: "PrimeRewardPool: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5db375799e35dab6780d41b7abe9ff997839700"
  family: "2c5c2ab321617b8c26cad483f9b7c2a4"
  copies: 2
  name: "PrimeRewardPool"
  label: "created by Strike ETH: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 68212
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x752d…d126"
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
  note: "Owner-gated setter, very active owner EOA."
---

## Summary

PrimeRewardPool: claim needs an ecrecover signature from `admin`. If admin takes code, claims revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- PrimeRewardPool.sol:31 setAdmin(address) onlyOwner replaces the signer; claim checks signatory == admin (l.53-54)
- owner() 0x752dfb1c…d126 is an EOA with nonce 3135; admin 0x89b24455…c723 is an EOA with nonce 0
- owner also has recoverBEP20 (l.67) to move pool tokens

## Impact and exposure

- Value held at block 26,438,999: $68,212 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setAdmin with a fresh EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
