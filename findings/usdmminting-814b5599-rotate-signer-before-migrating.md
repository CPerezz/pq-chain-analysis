---
id: usdmminting-814b5599-rotate-signer-before-migrating
title: "USDmMinting: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x814b55996914911b2bb57a2069c918ae159d02f4"
  family: "7b0f60f17b73581456b0adaec1eef0fc"
  copies: 3
  name: "USDmMinting"
  upgradeable: "no"
  rating: LOW
  value_usd: 1594690
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 71
  last_active: 2026-11-17
  recoveries_14d: 16
fix:
  layer: onchain-config
  who_acts: "benefactor"
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
  note: "LOW: the benefactor's own setter and an alternative signature type."
---

## Summary

USDmMinting. verifyOrder recovers the benefactor or delegated signer on the EIP712 branch.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the account named signs (ECDSA or its ERC-1271), or a signer it delegated on chain. Read from source. Executed: a real transaction reverts with code at the signer.
- reading 7b0f60f1: an EIP1271 signature type exists; benefactors set delegated signers by direct call
- owner() = 0x954f9b8E, a Safe with threshold 1 of 3

## Impact and exposure

- Value held at block 26,438,999: $1.6M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 71 transactions called it in the 90 days before that block; last on 2026-11-17.
- 16 signature recoveries in the study's two-week trace window.

## Remediation

The benefactor switches to the EIP1271 type or sets a new delegated signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
