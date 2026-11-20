---
id: version-3c11e08e-entry-by-own-signature-only
title: "Version: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x3c11e08e5f391872dac90d43c4812a2aae595e68"
  family: "eea1c22a2294dcc09e45ada5e746ef93"
  name: "Version"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "prospective fund manager (calls setupFund from an EOA/7702 account)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Entry-only gate on creating a new fund; nothing held depends on it. LOW holds."
---

## Summary

Melonport Version (competition build): setupFund requires termsAndConditionsAreSigned, i.e. ecrecover of the T&C hash == msg.sender. Under EIP-8151 a caller with non-7702 code cannot create a fund; existing funds are unaffected.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Melonport Version termsAndConditionsAreSigned: the caller must sign the terms to create a fund; a caller with code cannot. Read (function text).
- Version.sol:2791-2806 setupFund requires termsAndConditionsAreSigned(v,r,s); :2845-2860 ecrecover(...) == msg.sender; the only ecrecover in the file
- shutDownFund (:2829) is gated by managerToFunds[msg.sender]/isShutDown, no signature; Fund redemption functions (redeemAllOwnedAssets, emergencyRedeem) take no signature
- at 26438999: balance 0, isShutDown=false, getLastFundId() underflows (no funds ever created)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

A would-be manager creates the fund from an EOA or 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
