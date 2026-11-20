---
id: wrapperlocketh-aa7427d8-rotate-signer-before-migrating
title: "WrapperLockEth: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaa7427d8f17d87a28f5e1ba3adbb270badbe1011"
  family: "a6020f295590cea5734d9c01cbdcd28f"
  copies: 2
  name: "WrapperLockEth"
  label: "deployed by Bitfinex: Deployer 3"
  upgradeable: "no"
  rating: LOW
  value_usd: 1680587
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 38
  last_active: 2026-11-04
fix:
  layer: onchain-config
  who_acts: "any current signer"
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
  note: "LOW: direct setter and live signers; funds unlock at expiry. The quoted source is from a sibling code."
---

## Summary

Bitfinex WrapperLockEth. An operator signature releases deposits early; a signer with code fails, and depositors wait for lock expiry.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- reading a6020f29: any current signer can add a signer by direct call
- owner() = 0xe1F3C653 (EOA, nonce 1854)

## Impact and exposure

- Value held at block 26,438,999: $1.7M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 38 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

A current signer adds a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
