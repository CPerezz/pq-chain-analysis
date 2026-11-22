---
id: authereumaccount-a7ad82f4-rotate-signer-before-migrating
title: "AuthereumAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa7ad82f4d1209ea99858d3ebbd1f8127ad675242"
  family: "edf9adda7806890423812ae22fc297b1"
  copies: 3853
  name: "AuthereumAccount"
  label: "created by Authereum: Proxy Factory V2019111500"
  upgradeable: "yes"
  rating: LOW
  value_usd: 60453
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "auth key holders of the account"
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
  note: "Key holders call the setter directly by msg.sender. The EOA key has never sent a transaction (nonce 0) but holds the key."
---

## Summary

AuthereumAccount (proxy): isValidSignature and meta-transactions need ecrecover signatures from an auth key (or a login key attested by one). An auth key with code cannot sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: isValidSignature by an auth key: the recovered address must be an auth key of the account / isValidSignature by a login key: a login key signs, and an auth key of the account signed for that login…. Read from source.
- AuthereumAccount.sol:893-926 addAuthKey/removeAuthKey gated by onlyAuthKeySenderOrSelf (msg.sender is an auth key, no signature)
- AuthKeyAdded logs at deploy (block 10333717): 0x3229d637…2ea4 (EOA, nonce 0) and 0x14a8d296…e89d (contract, 430 bytes); authKeys() is true for both at block 26438999
- upgradeToAndCall is onlySelf, reachable through an auth key

## Impact and exposure

- Value held at block 26,438,999: $60,453 (ETH and 49 priced tokens, over 3,853 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

An auth key (EOA or contract, by direct call) adds a fresh EOA auth key before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
