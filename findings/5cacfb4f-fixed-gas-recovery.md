---
id: 5cacfb4f-fixed-gas-recovery
title: "0x5cacfb4f: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x5cacfb4f18e51e1d04f720c3ed479eb1ba72167f"
  family: "9ca31caa71a30fc107916e27fdc4575e"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners"
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
  note: "The only exit is the signature-gated DELEGATECALL and there is no owner bypass or update path, so anything the owners hold would lock: HIGH. Value never lowers the rating (it holds nothing today)."
---

## Summary

164-byte assembly multisig: loops over signatures with a 3000-gas call to 0x01, checks the owner in storage, then DELEGATECALLs; execution becomes impossible.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x55-0x5a: PUSH1 0x01 PUSH2 0x0bb8 CALL, result POPped, then storage owner check reverts
- the only exit is DELEGATECALL at 0x9e
- native balance 0; WETH/USDC/USDT/DAI balanceOf(this) all 0; value_usd null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for funds; redeploy if used.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
