---
id: version-63a2442e-entry-by-own-signature-only
title: "Version: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x63a2442e4ad6c1c3c9c7e32021c2db37b8b34a25"
  family: "9722c0d412928002290f2453924a2128"
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
  note: "Entry-only gate; nothing held. LOW holds."
---

## Summary

Melonport Version (earlier build): setupFund requires ecrecover of the T&C hash == msg.sender. Under EIP-8151 a caller with non-7702 code cannot create a fund; existing funds are unaffected.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Melonport Version termsAndConditionsAreSigned: the caller must sign the terms to create a fund; a caller with code cannot. Read (function text).
- Version.sol:1572-1587 setupFund requires termsAndConditionsAreSigned; :1626-1640 ecrecover(...) == msg.sender
- shutDownFund (:1610) needs no signature; Fund redemption takes no signature
- at 26438999: balance 0, isShutDown=false, getLastFundId() = 0 (one fund created)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Create the fund from an EOA or 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
