---
id: safel2-0000fa3e-rotate-signer-before-migrating
title: "SafeL2: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0000fa3e509d629516ae56dc6fdd31047300114d"
  family: "cbf21f99097a2b70e5ebbaf5001dde0a"
  copies: 928
  name: "SafeL2"
  label: "deployed by Pimlico: ERC-4337 Bundler 12"
  upgradeable: "yes"
  rating: NONE
  value_usd: 228818
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3744
  last_active: 2026-11-17
  recoveries_14d: 339
fix:
  layer: none
  who_acts: "none"
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
  note: "Signer with code handled."
---

## Summary

Safe 1.5.0 singleton: owners confirm by ECDSA, eth_sign, ERC-1271 (v=0) or approved hash (v=1).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Safe 1.5.0 checkNSignatures: owners in ascending order; ECDSA, eth_sign, a contract owner (v=0) or a pre-approved hash (v=1). Read from source.
- checkNSignatures accepts ERC-1271 contract owners and approveHash/msg.sender (reading note)

## Impact and exposure

- Value held at block 26,438,999: $228,818 (ETH and 49 priced tokens, over 928 addresses).
- Activity: 3,744 transactions called it in the 90 days before that block; last on 2026-11-17.
- 339 signature recoveries in the study's two-week trace window.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
