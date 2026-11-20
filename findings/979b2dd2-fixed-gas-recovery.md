---
id: 979b2dd2-fixed-gas-recovery
title: "0x979b2dd2: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x979b2dd26bcf1b391ff5afa7b0c818209889a832"
  family: "acd4a1772d63a1cb880f56543bccf158"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy); players cannot act"
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
  note: "HIGH by mechanism: stakes are credited only by the callback and nothing else moves the rest. Exposure today is zero (paused, 0 ETH); new money enters only if the owner unpauses."
---

## Summary

Unverified betting contract: ETH leaves only through withdrawPayments(), which pays payments[msg.sender] credited by the random settlement. There is no owner withdraw or selfdestruct, so unsettled stakes have no exit. Currently paused with balance 0.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The only ETH-moving function is withdrawPayments (pays storage_map_a[msg.sender] <= store_at); owner functions are pause/unpause/setPresident/transferOwnership; president functions only send the random query [heimdall decompile]
- Game creation 0x31201063 requires !paused; joining 0x691046f3 requires an existing game within 1 day of its start [decompile]
- paused()=1, owner 0xd3c4ed0b731ade717fd0fdfac725f47b14bdc9ad, ETH balance 0 at block 26438999 [batch facts, cast balance]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Do not unpause; redeploy with working randomness.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
