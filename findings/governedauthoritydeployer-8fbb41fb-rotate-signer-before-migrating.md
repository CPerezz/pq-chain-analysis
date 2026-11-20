---
id: governedauthoritydeployer-8fbb41fb-rotate-signer-before-migrating
title: "GovernedAuthorityDeployer: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x8fbb41fbc83fb42d81c619f495fcf109e1a12e78"
  family: "fa7a7c3459c36b3ca6b4dead7247c46c"
  name: "GovernedAuthorityDeployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2
  last_active: 2026-11-10
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

`GovernedAuthorityDeployer` at `0x8fbb41fbc83fb42d81c619f495fcf109e1a12e78`. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.5.0 checkNSignatures: owners in ascending order; ECDSA, eth_sign, a contract owner (v=0) or a pre-approved hash (v=1). Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
