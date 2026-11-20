---
id: depositvault-ba834c58-rotate-signer-before-migrating
title: "DepositVault: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xba834c583231e79ea08aeb5e577317b105b10603"
  family: "913f23ef8d7671a6214188a2a839a9f5"
  copies: 4
  name: "DepositVault"
  upgradeable: "yes"
  rating: LOW
  value_usd: 19850
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72
  last_active: 2026-11-10
fix:
  layer: onchain-config
  who_acts: "owner / credential manager"
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
  note: "There is an admin setter and a live EOA owner that controls the credential manager."
---

## Summary

DepositVault: withdrawals need a quorum of administrator signatures (Solady ECDSA).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: settlement with executors and a credential manager set by functions. Bytecode and names.
- DepositVault.sol:378 setAdministrators callable only by credentialManager (0xf38B…05A6, a contract); :362 setCredentialManager onlyOwner with no delay
- owner 0x0194…3e8 is an EOA, nonce 300

## Impact and exposure

- Value held at block 26,438,999: $19,850 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 72 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

The credential manager, or the owner by swapping it, replaces the administrator set.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
