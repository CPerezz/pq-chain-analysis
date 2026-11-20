---
id: minimalaccount-aa4737ba-rotate-signer-before-migrating
title: "MinimalAccount: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaa4737ba58625f442d0ca6018ea04e3830537984"
  family: "dd54c4b3de594bdb9369d883d373309f"
  copies: 2473
  name: "MinimalAccount"
  upgradeable: "no"
  rating: LOW
  value_usd: 21474
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 55792
  last_active: 2026-11-18
  recoveries_14d: 17780
fix:
  layer: account-migration
  who_acts: "account owner (EOA)"
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
  note: "The own-key check passes under EIP-8151 while the account stays 7702-delegated, and session keys are rotated by the account itself. 55,792 txs in 90d."
---

## Summary

MinimalAccount is an EIP-7702 delegate (code 0xef0100 3e5155…). It accepts its own key (recovered == address(this)) or session keys that the account created.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: MinimalAccount: the account's own key, or a session key whose policies the account set. Read by hand.
- MinimalAccount.sol:221/236 recovered must be address(this) or a session signer; createSessionWithSig needs the account's own signature
- address(this) is a 7702-delegated EOA, which EIP-8151 still accepts; a session key with code just gets replaced with a new session

## Impact and exposure

- Value held at block 26,438,999: $21,474 (ETH and 49 priced tokens, over 2,473 addresses).
- Activity: 55,792 transactions called it in the 90 days before that block; last on 2026-11-18.
- 17,780 signature recoveries in the study's two-week trace window.

## Remediation

The account creates a new session key, or re-delegates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
