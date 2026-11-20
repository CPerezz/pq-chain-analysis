---
id: b1a71b35-fixed-gas-recovery
title: "0xb1a71b35: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0xb1a71b3526a3494857c4ef873f7702a11e2e3265"
  family: "c5aac38b7987f4ff4e43a8c2b40b923e"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 26
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-10-29
fix:
  layer: none
  who_acts: "nobody can; the operator's bond is exposed"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "CRITICAL: a wrong fraud verdict slashes an honest operator who did nothing wrong, no update path."
---

## Summary

Fuel v1 bridge (24,361 bytes). Its recover routine ignores the CALL result and reads back a junk address, so after activation a fraud proof against an honestly signed block succeeds and pays its caller from the operator's bond.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 85 86 6001 610bb8 f1 50 60a0 51, a constant 3,000-gas CALL to 0x01, success POPped, result read from mload(0xa0) as in 0x6880
- same call-site pattern as 0x6880f6, which the study executed by hand (honest block is proven fraudulent)
- operator() 0x9af7…fe94; 8 txs in 90 days, last active 2026-10-29 (dormant/low-value does not lower this rating: the mechanism is rated as if it held money)

## Impact and exposure

- Value held at block 26,438,999: $26 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-10-29.

## Remediation

Operator must exit and abandon this bridge before activation; no upgrade path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
