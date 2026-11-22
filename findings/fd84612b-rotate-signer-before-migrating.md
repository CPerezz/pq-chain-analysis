---
id: fd84612b-rotate-signer-before-migrating
title: "0xfd84612b: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfd84612b395da9459ef47f9f4598a0be6d9f3e29"
  family: "008d5e1f49ff03fefce8204499bc6c09"
  copies: 28
  upgradeable: "no"
  rating: LOW
  value_usd: 85897
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 25593
  last_active: 2026-11-18
  recoveries_14d: 1226
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xd79e…3395"
evidence:
  level: executed
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
  note: "Owner-gated setter verified by simulation; owner is an active EOA."
---

## Summary

Unverified signer-committee settlement pool (EIP-712 domain 'LibertySwap'): releases need threshold signatures from stored signers, checked by ecrecover only. A signer that takes code stops counting.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: signers with a threshold; updateSigner and setSignatureThreshold change them. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- updateSigner(address,bool) simulated at block 26438999: succeeds from owner 0xd79ee932…3395, reverts from a random caller with OwnableUnauthorizedAccount (0x118cdaa7)
- owner 0xd79ee932…3395 is an EOA with nonce 426
- getSigners() = 3 signers; setSignatureThreshold is also callable by the owner (simulated, returns ok)

## Impact and exposure

- Value held at block 26,438,999: $85,897 (ETH and 49 priced tokens, over 28 addresses).
- Activity: 25,593 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,226 signature recoveries in the study's two-week trace window.

## Remediation

Owner replaces a migrating signer via updateSigner (and adjusts threshold) before it takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
