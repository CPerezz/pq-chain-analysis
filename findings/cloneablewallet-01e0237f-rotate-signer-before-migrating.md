---
id: cloneablewallet-01e0237f-rotate-signer-before-migrating
title: "CloneableWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x01e0237fddb7e169dcc34c724d4ef09cd7c2eff8"
  family: "74ac18cec1fce043cede46c59c144b01"
  copies: 1371
  name: "CloneableWallet"
  label: "deployed by Portto: Hot Wallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet's authorized key or recovery address"
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
  note: "The key holder rotates it via the msg.sender paths or recovery."
---

## Summary

Dapper CloneableWallet: invoke1/invoke2 and ERC-1271 recover authorized signer/cosigner keys. A key with code can no longer sign, but it can still act as msg.sender.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Dapper wallet ERC-1271: signer and cosigner must be a pair recorded in the wallet's authorizations / Dapper wallet invoke1CosignerSends: the recovered address is an authorized key, the caller its…. Read from source.
- CloneableWallet.sol:810-818 invoke0 / 876 invoke1SignerSends take msg.sender as the signer (no ecrecover for that key)
- setAuthorized and setRecoveryAddress are onlyInvoked; emergencyRecovery (line 643) is onlyRecoveryAddress
- recoveryAddress() 0x25Ef0eA6…: no code, nonce 0 (a key that can send directly)

## Impact and exposure

- Value held at block 26,438,999: $15,519 (ETH and 49 priced tokens, over 1,371 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The wallet holder re-authorizes a fresh key via setAuthorized (invoke) or emergencyRecovery.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
