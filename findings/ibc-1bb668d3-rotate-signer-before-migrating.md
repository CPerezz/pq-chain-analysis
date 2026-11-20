---
id: ibc-1bb668d3-rotate-signer-before-migrating
title: "Ibc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1bb668d33d367702adbe81346d57d5e5083fa346"
  family: "1745c7c0932c68650f985d50f9cd052c"
  copies: 2
  name: "Ibc"
  upgradeable: "no"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2716
  last_active: 2026-11-17
  recoveries_14d: 1188
fix:
  layer: onchain-config
  who_acts: "owner Safe 4/7"
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
  note: "Setter callable by a live 4/7 Safe."
---

## Summary

Ibc bridge; messages need a minimum number of oracle signatures (oraclePublicKeys). Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Ibc bridge: a minimum number of distinct signers from the oracle set (oraclePublicKeys). Read from source.
- Ibc.sol:109/115 addOracle/removeOracle onlyOwner
- owner() = 0x95d49078…, a Safe with 7 owners, threshold 4

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,716 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1,188 signature recoveries in the study's two-week trace window.

## Remediation

Owner Safe adds a new oracle and removes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
