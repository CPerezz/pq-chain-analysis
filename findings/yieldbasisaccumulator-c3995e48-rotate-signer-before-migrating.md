---
id: yieldbasisaccumulator-c3995e48-rotate-signer-before-migrating
title: "YieldBasisAccumulator: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc3995e48713e6f734657dc4e70558e3a1ba50848"
  family: "632da7d52db79cf8c0a4714e9c49a403"
  name: "YieldBasisAccumulator"
  upgradeable: "no"
  rating: NONE
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 12
  last_active: 2026-11-12
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

`YieldBasisAccumulator` at `0xc3995e48713e6f734657dc4e70558e3a1ba50848`. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.5.0 checkNSignatures: owners in ascending order; ECDSA, eth_sign, a contract owner (v=0) or a pre-approved hash (v=1) / Solady ERC20 permit (variant, assembly): the recovered address must be…. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 12 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
