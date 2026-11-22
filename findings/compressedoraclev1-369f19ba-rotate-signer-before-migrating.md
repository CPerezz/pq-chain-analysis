---
id: compressedoraclev1-369f19ba-rotate-signer-before-migrating
title: "CompressedOracleV1: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x369f19ba423493f0457431d39417e6f6e0c875ff"
  family: "d0e339c9814711196974bf74b66885e3"
  copies: 3
  name: "CompressedOracleV1"
  upgradeable: "no"
  rating: LOW
  txs_90d: 304479
  last_active: 2026-11-18
  recoveries_14d: 7
fix:
  layer: onchain-config
  who_acts: "feed creator / pusher"
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
  note: "signed shortcuts with direct paths open to the same party"
---

## Summary

CompressedOracleV1: signed pusher consent (allowPushers) and creator-signed updateBySignature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: CompressedOracle allowPushers: each pusher signs its consent to push for the caller / CompressedOracle updateBySignature: the update must be signed by the feed creator named; a feed lives under its…. Read from source. Executed: a real transaction reverts with code at the signer.
- CompressedOracle.sol fallback lets a creator (or its remapped pusher) push directly without a signature
- allowContractPushers maps a pusher that has code via isPusher(), no ecrecover; revokePusher/removePushers are direct calls

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 304,479 transactions called it in the 90 days before that block; last on 2026-11-18.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

creator pushes directly, or registers a contract pusher via allowContractPushers

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
