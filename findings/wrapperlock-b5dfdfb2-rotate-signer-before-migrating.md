---
id: wrapperlock-b5dfdfb2-rotate-signer-before-migrating
title: "WrapperLock: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb5dfdfb2a1c97b329361d261239c51e5f88d035d"
  family: "d90294408447f5e02510ddd488e832ff"
  copies: 46
  name: "WrapperLock"
  label: "deployed by Bitfinex: Deployer 3"
  upgradeable: "no"
  rating: LOW
  value_usd: 47460
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-07
fix:
  layer: onchain-config
  who_acts: "any current signer (key holder); users after their own lock"
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
  note: "The key holder can add a new signer, and the act stays open by waiting out the user's own lock. Signer set not enumerable (no events), so signer liveness is not read."
---

## Summary

Bitfinex/Ethfinex WrapperLock: withdrawal before a deposit's lock expires needs a signature from an isSigner key (ECDSA only). A signer with code stops early unlocks.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- WrapperLock.sol:248-250: the signature is required only while now <= depositLock[msg.sender]; after that, withdraw needs no signature
- deposit sets the lock to the user's own _forTime (>=1 hour)
- addSigner (line 315) is callable by any current signer, which is the key holder itself; there is no removal function

## Impact and exposure

- Value held at block 26,438,999: $47,460 (ETH and 49 priced tokens, over 46 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-07.

## Remediation

A live signer adds a fresh EOA signer; users can withdraw unsigned once their lock expires.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
