---
id: caliburentry-ce890746-rotate-signer-before-migrating
title: "CaliburEntry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xce890746664e17a3220e1f64d1b7f86c1e4be4b2"
  family: "545783d93e913a4554fc99faccb15177"
  copies: 159930
  name: "CaliburEntry"
  label: "Uniswap: EIP-7702 Delegator 1"
  upgradeable: "no"
  rating: LOW
  value_usd: 34914988
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 382964
  last_active: 2026-11-18
  recoveries_14d: 17291
fix:
  layer: onchain-config
  who_acts: "the account"
evidence:
  level: bytecode
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
  note: "LOW: the account controls its keys."
---

## Summary

Uniswap Calibur 7702 delegator (160k EOAs). The root key is exempt; registered secp256k1 keys that take code lose use.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: 7702 account logic (159,930 accounts): the account's own key, and keys it registered (compared with values the scanner cannot name). Bytecode and names.
- reading 545783d9: the root signer is the account itself; registered keys are compared
- key registration and revocation run through the account's own calls

## Impact and exposure

- Value held at block 26,438,999: $34.9M (ETH and 49 priced tokens, over 159,930 addresses).
- Activity: 382,964 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,291 signature recoveries in the study's two-week trace window.

## Remediation

Revoke and re-register the key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
