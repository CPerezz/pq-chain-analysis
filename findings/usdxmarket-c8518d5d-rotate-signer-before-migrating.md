---
id: usdxmarket-c8518d5d-rotate-signer-before-migrating
title: "USDxMarket: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc8518d5de0451c67a20da2b1dc54d68569018ca3"
  family: "cfadd73232f2483070f1b46d50f7cc97"
  copies: 10
  name: "USDxMarket"
  upgradeable: "no"
  rating: LOW
  value_usd: 424072
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 157
  last_active: 2026-11-17
  recoveries_14d: 14
fix:
  layer: account-migration
  who_acts: "user (order signer)"
evidence:
  level: executed
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
  note: "Direct-call delegate setter for the affected user."
---

## Summary

USDx mint/redeem order settlement: user's EIP-712 order checked by ECDSA, ERC-1271 or an on-chain delegated signer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the account named signs (ECDSA or its ERC-1271), or a signer it delegated on chain. Read from source. Executed: a real transaction reverts with code at the signer.
- setDelegatedSigner/removeDelegatedSigner by user direct call, delegate confirms by direct call (reading.keys)
- signature check also accepts ERC-1271 for the named account
- live proxy 0x5ae365ac…f58c, EIP-1967 admin 0x70a679cf…98ba

## Impact and exposure

- Value held at block 26,438,999: $424,072 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 157 transactions called it in the 90 days before that block; last on 2026-11-17.
- 14 signature recoveries in the study's two-week trace window.

## Remediation

User enrolls an EOA delegate (or uses ERC-1271).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
