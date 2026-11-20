---
id: fuel-6880f6fd-fixed-gas-recovery
title: "Fuel v1: fixed gas for ecrecover below EIP-8151's price"
project: fuel
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  family: "9f4806d946187002751eeaec773042b2"
  name: "Fuel v1"
  label: "Fuel: Bridge"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-16
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
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "CRITICAL: an honest party is punished by a wrong fraud verdict, no update path."
---

## Summary

Fuel v1 bridge. The recover routine gives 0x01 3,000 gas, ignores failure and reads a junk address, so a fraud proof against an honestly signed block succeeds and pays its caller from the operator's bond (executed by hand in the study).

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Executed by hand: see Evidence. Rated by hand: executed: a fraud proof against an honestly signed block succeeds and pays its caller from the operator's bond.
- Fuel v1 `0x6880f6fd960d1581c2730a451a22eed1081cfd72`: `src/Witness.yulp` L137–144 of FuelLabs/fuel-v1-contracts@2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22 does `call(3000, 1, 0, 0, 128, 160, 32)` and ignores the result. Executed (`eth_simulateV1`, block 26,438,999): with a recovery that cannot finish in 3,000 gas, `proveInvalidWitness` on an honestly signed transaction emits `FraudCommitted(9, 8, 150)` and pays the caller 0.25 ETH; today it finds nothing.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x2a70: PUSH1 0x01 PUSH2 0x0bb8 CALL POP PUSH1 0xa0 MLOAD, constant gas and success ignored
- row note: hand execution shows an honest block proven fraudulent and the bond paid out
- operator() 0xfa99…e39c; no proxy; 6 txs in 90 days, last active 2026-11-16 (held value is small; not used to set this rating)

## Impact and exposure

- Value held at block 26,438,999: $18 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Operator must exit and abandon this bridge before activation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
