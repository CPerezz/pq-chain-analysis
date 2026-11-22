---
id: compressedoraclev1-369f19ba-entry-by-own-signature-only
title: "CompressedOracleV1: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
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
  layer: offchain
  who_acts: "feed creator / pushers"
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
  note: "No value held; the oracle signer gets in by other paths (allowContractPushers). value_usd None, txs_90d 304479."
---

## Summary

CompressedOracleV1: feed creators can update by signature, and pushers consent to push by signature.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: CompressedOracle allowPushers: each pusher signs its consent to push for the caller / CompressedOracle updateBySignature: the update must be signed by the feed creator named; a feed lives under its…. Read from source. Executed: a real transaction reverts with code at the signer.
- CompressedOracle.sol:344 updateBySignature requires feedCreator == ECDSA.recover(...)
- CompressedOracle.sol:240 allowPushers per-pusher signature; l.263 allowContractPushers lets a creator authorise contract pushers without a signature
- creator-as-caller update path not re-traced beyond these functions

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 304,479 transactions called it in the 90 days before that block; last on 2026-11-18.
- 7 signature recoveries in the study's two-week trace window.

## Remediation

Creators with code push directly, or allow a contract pusher via allowContractPushers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
