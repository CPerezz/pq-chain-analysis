---
id: d83e611a-rotate-signer-before-migrating
title: "0xd83e611a: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd83e611af1bb562db4702fcca44f34a859950514"
  family: "037da16fc95cf6f6299a267170a4454f"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3670
  last_active: 2026-11-18
  recoveries_14d: 739
fix:
  layer: onchain-config
  who_acts: "owner 0x5dfF6344…9e13 (EOA)"
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
  note: "Owner-only setter, live EOA."
---

## Summary

Unverified contract checking a stored signer() by ecrecover. A signer with code makes calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall: setSigner(address) and setOwner(address) require msg.sender == owner
- signer() = 0x2911085e…; owner() = 0x5dfF63445b53D1DC8BCB2cf2081b3DC4cf9d9e13, no code, nonce 33

## Impact and exposure

- Value held at block 26,438,999: $2,707 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,670 transactions called it in the 90 days before that block; last on 2026-11-18.
- 739 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
