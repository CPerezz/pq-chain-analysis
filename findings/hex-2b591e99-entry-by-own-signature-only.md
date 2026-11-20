---
id: hex-2b591e99-entry-by-own-signature-only
title: "HEX: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: none
contracts:
- address: "0x2b591e99afe9f32eaa6214f7b7629768c40eeb39"
  family: "67378a73f4c71f751b5ac65a0a6ddfad"
  copies: 2
  name: "HEX"
  label: "HEX.com: HEX Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 31219
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 72973
  last_active: 2026-11-18
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
  note: "Path dead since 2020; nothing held depends on it. value_usd 31219, txs_90d 72973."
---

## Summary

HEX token: the BTC-address claim needs a signature from the claimant's Ethereum key; the claim phase ended in 2020.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: HEX Bitcoin claim: the Bitcoin key's Ethereum address must have signed the claim; the claim phase ended in 2020. Read from source.
- HEX source l.1964 btcAddressClaim: require(day < CLAIM_PHASE_END_DAY, "HEX: Claim phase has ended")
- transfers, staking and stake ends are msg.sender-based (no ecrecover)

## Impact and exposure

- Value held at block 26,438,999: $31,219 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 72,973 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed (claim window closed)

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
