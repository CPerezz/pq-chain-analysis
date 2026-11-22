---
id: etherflip-e5a04d98-fixed-gas-recovery
title: "EtherFlip: fixed gas for ecrecover below EIP-8151's price"
project: etherflip
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xe5a04d98538231b0fab9aba60cd73ce4ff3039df"
  family: "0fa7b998d3ca2517f15886d2653dd1ef"
  name: "EtherFlip"
  label: "EtherFlip"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1359029
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner refunds open bets and moves the bankroll before activation"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "game stops from day one; money leaves through the owner's refundTransfer; dormant"
---

## Summary

`EtherFlip` at `0xe5a04d98538231b0fab9aba60cd73ce4ff3039df`. Its Oraclize proof check gives ecrecover a constant 3,000 gas, so from activation day no bet resolves; the owner can still move the money out without any signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode. Rated by hand: read: the owner moves the bankroll with refundTransfer, no signature needed; read: the owner moves the bankroll without a signature.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: safer_ecrecover calls the precompile with a constant 3,000 gas; verifySig ignores its result flag, so every Oraclize proof fails under EIP-8151.
- A way out stays: the owner (0x165c74e3954817d007a2038bac8eaaed87c982fa, an EOA) moves the bankroll with refundTransfer, which needs no signature; updateOwner changes the owner.
- No proxy slot, no upgrade function. No transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner refunds what is open and withdraws before activation; a new deployment with a correct gas stipend if the game should go on.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
