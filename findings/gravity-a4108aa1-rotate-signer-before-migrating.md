---
id: gravity-a4108aa1-rotate-signer-before-migrating
title: "Gravity: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa4108aa1ec4967f8b52220a4f7e94a8201f2d906"
  family: "6727a783ca6298115b18fe4a115d513d"
  name: "Gravity"
  label: "Gravity Bridge: Bridge"
  upgradeable: "no"
  rating: LOW
  value_usd: 10827
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 578
  last_active: 2026-11-17
  recoveries_14d: 496
fix:
  layer: onchain-config
  who_acts: "Gravity validator set (orchestrators)"
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
  note: "Rotation exists and is actively used by a live validator set: LOW. Quorum is lost only if enough power migrates at once."
---

## Summary

The Gravity bridge checks each validator signature with ECDSA.recover against the checkpointed validator set. A validator whose key gets code stops counting toward the power threshold.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Gravity bridge: as Peggy: the validator set is replaced by updateValset, signed by the current set. Read by hand. Executed: a real transaction reverts with code at the signer.
- Gravity.sol:161 _signer == ECDSA.recover; updateValset replaces the set when signed by the current set above the power threshold (checkValidatorSignatures :139)
- state_lastValsetNonce()=3011 at block 26438999; txs_90d 578, last active 2026-11-17, so the set is rotated actively

## Impact and exposure

- Value held at block 26,438,999: $10,827 (ETH and 49 priced tokens).
- Activity: 578 transactions called it in the 90 days before that block; last on 2026-11-17.
- 496 signature recoveries in the study's two-week trace window.

## Remediation

Validators rotate their Ethereum orchestrator keys to EOAs through a normal updateValset while quorum still holds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
