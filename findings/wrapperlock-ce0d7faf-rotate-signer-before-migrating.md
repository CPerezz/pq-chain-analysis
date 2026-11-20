---
id: wrapperlock-ce0d7faf-rotate-signer-before-migrating
title: "WrapperLock: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xce0d7faf97604dcdb5b775b57198c0719c119f71"
  family: "87aa1458a6a9ae6fc2e883dde32c2b4a"
  copies: 24
  name: "WrapperLock"
  label: "deployed by Bitfinex: Deployer 6"
  upgradeable: "no"
  rating: LOW
  value_usd: 10106
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-07
fix:
  layer: onchain-config
  who_acts: "current signer 0x14d06788090769f669427b6aea1c0240d2321f34"
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
  note: "A live signer can add keys: LOW. Contract balance 0, totalSupply 0."
---

## Summary

OMG WrapperLock signed withdraw requires isSigner[ecrecover(...)]. Signed unlocks die if every signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- source:443-446 addSigner(address) requires isSigner[msg.sender]; :435 isSigner[ecrecover]
- isSigner(0x14d0…1f34)=true; it is the owner and a 7702-delegated EOA (0xef0100…), nonce 618, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $10,106 (ETH and 49 priced tokens, over 24 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-07.

## Remediation

An existing signer adds a new EOA signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
