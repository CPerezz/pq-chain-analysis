---
id: wallet-9b5d9e2c-rotate-signer-before-migrating
title: "Wallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9b5d9e2c2e1e96986603be922bc44304d6aca898"
  family: "413f5025dc6f28c1511305dfb6fe3622"
  name: "Wallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 32
  last_active: 2026-11-17
  recoveries_14d: 1
fix:
  layer: onchain-config
  who_acts: "owner/admin 0xb3293087c440b8663fbe04190de132f71dfd8d29"
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
  note: "The key holder is also the owner, so it can rotate its own key: LOW. Attention: the owner has never sent a transaction (nonce 0); it only signs off-chain (txs_90d 32)."
---

## Summary

This Wallet's withdraw requires ecrecover == admin. Signed withdrawals die if admin gets code; the owner keeps ownerWithdraw.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be one stored signer of the contract (an affiliate, system, consensus, updater, admin or whitelist key). Read from source.
- source:137 setAdmin(address) onlyOwner; :222 ecrecover == admin
- owner()=admin()=0xb329…8d29: no code, nonce 0 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,106 (ETH and 49 priced tokens).
- Activity: 32 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

The owner (the same key) calls setAdmin with a new EOA key before taking code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
