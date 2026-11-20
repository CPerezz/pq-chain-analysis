---
id: cloneablewallet-0af7f216-rotate-signer-before-migrating
title: "CloneableWallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0af7f2162b4714c99f49b8c4fb4f3cece026b432"
  family: "ca85fe9aaadf0b3fbf8a7518ba398149"
  copies: 7202
  name: "CloneableWallet"
  label: "deployed by Portto: Hot Wallet"
  upgradeable: "no"
  rating: LOW
  value_usd: 26166
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owner (recovery key)"
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
  note: "Wallet owner's recovery key replaces keys by direct call."
---

## Summary

Dapper CloneableWallet: invoke paths need signer/cosigner pairs from authorizations; recovered keys with code fail.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Dapper wallet ERC-1271: signer and cosigner must be a pair recorded in the wallet's authorizations / Dapper wallet invoke1CosignerSends: the recovered address is an authorized key, the caller its…. Read from source.
- emergencyRecovery(address,uint256) is onlyRecoveryAddress (direct call) and resets the authorized key/cosigner (CloneableWallet.sol:541)
- recoveryAddress() = 0x9907…1fac, EOA nonce 0 (no code)
- invoke1SignerSends lets the authorized key send directly with only the cosigner's signature

## Impact and exposure

- Value held at block 26,438,999: $26,166 (ETH and 49 priced tokens, over 7,202 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Recovery key calls emergencyRecovery with a new pair, or the user sets new authorizations via invoke.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
