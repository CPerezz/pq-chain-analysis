---
id: nettensor-ba0152f0-rotate-signer-before-migrating
title: "Nettensor: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xba0152f01f33946742d1bb0b14015d8d8944c6ec"
  family: "2ff8c4d530e9231a588181fb31f9ca98"
  copies: 15
  name: "Nettensor"
  label: "OpSec: OPSEC Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 11369
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 319
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "owner 0xc71fd0c9fc2a7ba87c67e77a6f75bc8d6a66c3de"
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
  note: "The key can be replaced through transferOwnership by a live EOA, and the signed act has already run: LOW."
---

## Summary

The Nettensor/DAO token's trading switch needs an EIP-712 'Enable Trading' signature recovered to owner(). Trading is already on, so EIP-8151 changes nothing in practice.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner of the contract. Read from source.
- Nettensor.sol:678-682 ecrecover(digest)==owner() then tradingActive=true (a one-shot switch)
- tradingActive()=true at block 26438999
- transferOwnership(address) onlyOwner; owner()=0xc71f…c3de is an EOA with nonce 10

## Impact and exposure

- Value held at block 26,438,999: $11,369 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 319 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None needed; trading is already active. The owner can transfer ownership to an EOA if the switch is ever needed again.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
