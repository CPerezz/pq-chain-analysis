---
id: salev2-6453f5cc-rotate-signer-before-migrating
title: "SaleV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6453f5cc7d1b03f416a35eea212344d955d87008"
  family: "e5622a48959305c405bfa7278c961988"
  name: "SaleV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 41685
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 21
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "default admin 0xac7e85d3 (EOA)"
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
  note: "Setter exists and the default admin is a live EOA."
---

## Summary

SaleV2 token sale: purchases/claims need an EIP-712 signature from operator, ECDSA only. An operator with code makes those calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- SaleV2.sol:905-907 ECDSA.recover(...) != operator reverts; :513 setOperator onlyRole(DEFAULT_ADMIN_ROLE)
- defaultAdmin() at block 26438999 = 0xAc7e85D3c232a76b3b916D9278D80b0AD4B6ca3E, no code, nonce 21; operator 0x47873cc0 has no code

## Impact and exposure

- Value held at block 26,438,999: $41,685 (ETH and 49 priced tokens).
- Activity: 21 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Default admin calls setOperator with an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
