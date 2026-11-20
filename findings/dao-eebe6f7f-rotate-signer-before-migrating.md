---
id: dao-eebe6f7f-rotate-signer-before-migrating
title: "Dao: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xeebe6f7fd87ed28748f5e4d3e339ba0f28e90782"
  family: "6fff5ce63b9c3d0c5b6ef913ee26a23a"
  copies: 712
  name: "Dao"
  label: "created by XDAO: Factory"
  upgradeable: "no"
  rating: LOW
  value_usd: 37174
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-09-20
fix:
  layer: account-migration
  who_acts: "the signer (token holder)"
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
  note: "the key holder itself rotates by transferring its weight to a new key; no external party needed."
---

## Summary

XDAO Dao: proposal signatures are recovered and their GP-token balances summed against quorum; a holder whose account takes code loses its vote.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: XDAO: the signers' balances of the DAO's token are summed against the quorum; a holder moves its weight by transferring the token. Read from source.
- Dao.sol:273 ethSignedHash.recover(_sigs[i]) weighted by token balance
- holder moves weight by transferring its token (transfer/transferFrom are exits)

## Impact and exposure

- Value held at block 26,438,999: $37,174 (ETH and 49 priced tokens, over 712 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-09-20.

## Remediation

rotate the signer key before the account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
