---
id: synthetixdepositcontract-d62595c3-rotate-signer-before-migrating
title: "SynthetixDepositContract: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd62595c3c23b690baee0935e107a209cb1dbd37b"
  family: "86cb27da6f656bf2d5a3c678c88509ae"
  copies: 5
  name: "SynthetixDepositContract"
  label: "Synthetix: Deposit"
  upgradeable: "yes"
  rating: LOW
  value_usd: 851752
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 505
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "Synthetix Safe (4 of n)"
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
  note: "LOW: live Safe holds the admin roles."
---

## Summary

SynthetixDepositContract. An authorised trader's ECDSA signature validates CoW orders via isValidSignature; deposits and withdrawals are untouched.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- reading 86cb27da: MANAGER_ROLE or OWNER_ROLE grant and revoke the trader role
- getRoleMember(OWNER_ROLE,0) = getRoleMember(MANAGER_ROLE,0) = 0xEb310711, a Safe with getThreshold 4

## Impact and exposure

- Value held at block 26,438,999: $851,752 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 505 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The Safe grants the trader role to a new EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
