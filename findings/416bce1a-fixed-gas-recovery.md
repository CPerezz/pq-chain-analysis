---
id: 416bce1a-fixed-gas-recovery
title: "0x416bce1a: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x416bce1aaeb6b46f4b67d72d3707a92c480544f1"
  family: "1ad5158a60087c28c30bf8e7373c70a6"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody can recover the pot; owner 0x285ee70c… can only change parameters"
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
  rating: HIGH
  note: "HIGH: same locked-pot mechanism as 0x51a46d… (rated HIGH) — rated by mechanism, not by today's balance, per the instruction that a dormant copy of a locking defect stays rated at its mechanism's severity"
---

## Summary

HEXLOTTO variant (same owner, same source family as 0x51a46d…): Provable random-DS callback with a 3000-gas safer_ecrecover, so draws revert and any ticket pot is never paid out; the owner has no withdraw of the pot.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- scanner: CALL pc 17504, gas const 3000, target 0x01; decompile shows finishHourly/Monthly/Yearly and the Provable callbacks, same structure as the verified HEXLOTTO.sol sibling
- owner functions are only parameter setters (no pot withdraw), matching 0x51a46d…; owner 0x285ee70ca0caa154f1fb3c2002e9876e2057b98d is an EOA
- native balance 0 ETH; the HEX token balanceOf(this) was not queried for this address (only for 0x51a46d…), so a currently-empty pot is possible but unconfirmed

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain: the pot (if any) stays locked; a revived lottery needs a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
