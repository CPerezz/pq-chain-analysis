---
id: gnosissafe-0a4fd9eb-rotate-signer-before-migrating
title: "GnosisSafe: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0a4fd9ebe5d8ebf63b1ab77a3296e2d79884b48e"
  family: "132235e39b2554a55aa75d85533b26a4"
  copies: 965
  name: "GnosisSafe"
  label: "deployed by Safe: Relay service - Deployment"
  upgradeable: "yes"
  rating: LOW
  value_usd: 46831941
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-11-08
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "Safe owners"
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
  note: "LOW: self-rotation plus alternative paths."
---

## Summary

Gnosis Safe 1.0.0. An owner with code loses ECDSA signatures in checkSignatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: old Safe SignatureDecoder.recoverKey: returns the recovered address / Safe 1.0.0 checkSignatures: owners in ascending order; ECDSA, a contract owner (v=0) or a hash the owner approved by its own call…. Read from source. Executed: a real transaction reverts with code at the signer.
- reading 132235e3: approveHash, sending execTransaction itself, and legacy isValidSignature(bytes,bytes) remain
- owners are rotated by the Safe through its own transaction

## Impact and exposure

- Value held at block 26,438,999: $46.8M (ETH and 49 priced tokens, over 965 addresses).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-08.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Swap the owner first or use the other confirmation paths.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
