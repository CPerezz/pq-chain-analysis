---
id: tokenvaultportal-5c03e4e3-rotate-signer-before-migrating
title: "TokenVaultPortal: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x5c03e4e3b9c3d5c8ef4ceba81dc118f652e26c29"
  family: "ec54d0a433f06b16cca1718a940aabc7"
  name: "TokenVaultPortal"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`TokenVaultPortal` at `0x5c03e4e3b9c3d5c8ef4ceba81dc118f652e26c29`. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Aztec ValidatorSelectionLib verifyAttestations: the epoch committee from the staking set / Aztec SignatureLib.verify: must equal the signer its caller names: the slot's proposer taken from the…. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
