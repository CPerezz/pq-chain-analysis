---
id: btcdminting-d22fff18-rotate-signer-before-migrating
title: "BTCDMinting: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd22fff18b5e25ef1f07f8e194b89966652d44f5b"
  family: "ec85fa6369ace387ea8524d06c0755ec"
  copies: 2
  name: "BTCDMinting"
  label: "deployed by Bitcoin Dollar: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 20752
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 200
  last_active: 2026-11-16
  recoveries_14d: 4
fix:
  layer: onchain-config
  who_acts: "benefactor (user)"
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
  note: "The user rotates the key themselves, and the 1271 branch covers benefactors whose code implements it. The study replayed a revert on the ECDSA path, so not refuted. 200 txs in 90d."
---

## Summary

BTCDMinting: orders are signed by the benefactor or by a delegated signer it confirmed (ECDSA), with a separate EIP1271 signature type for contract benefactors.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the benefactor named signs by ECDSA, or a signer it delegated on chain; the ERC-1271 branch is past the cut of my view. Read from source. Executed: a real transaction reverts with code at the signer.
- BTCDMinting.sol:570-598 ECDSA signer must be the benefactor or delegatedSigner[benefactor][signer]==CONFIRMED; the EIP1271 type calls benefactor.isValidSignature
- setDelegatedSigner (:370), called by the benefactor directly, rotates the signing key; removeDelegatedSigner too
- owner 0x64fe…308 is an EOA, nonce 19

## Impact and exposure

- Value held at block 26,438,999: $20,752 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 200 transactions called it in the 90 days before that block; last on 2026-11-16.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

A benefactor with code signs via EIP1271, or delegates a fresh EOA signer through setDelegatedSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
