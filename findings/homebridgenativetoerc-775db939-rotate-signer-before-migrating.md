---
id: homebridgenativetoerc-775db939-rotate-signer-before-migrating
title: "HomeBridgeNativeToErc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x775db93999c339e04276040069e2a08aaf3c13d4"
  family: "9c8a31f6d14efbd90466a53878047f59"
  copies: 2
  name: "HomeBridgeNativeToErc"
  upgradeable: "yes"
  rating: LOW
  value_usd: 124876
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "validator contract owner"
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
  note: "live EOA owner of validator set"
---

## Summary

POA HomeBridge: validators (validator contract) sign; set kept in validator contract.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: POA/Gnosis bridge: requiredSignatures distinct signers that the validators contract accepts (isValidator); the set is kept and changed in that other contract (not read here) / POA home bridge…. Read from source.
- validatorContract 0xef3892… owner 0x2c1686… EOA nonce 23; upgradeabilityOwner 0xed5654… EOA nonce 18 (node block 26438999)
- requiredSignatures 1, one validator 0x9035…

## Impact and exposure

- Value held at block 26,438,999: $124,876 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

validator-contract owner replaces validators

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
