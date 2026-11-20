---
id: luckystrike-bfb45549-fixed-gas-recovery
title: "LuckyStrike: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0xbfb45549e5630e1f4e6bb4d3f7132563100e08c9"
  family: "1ab8a524d80fff349ff9eb286a2362cb"
  copies: 2
  name: "LuckyStrike"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2070
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody can for the jackpot pools"
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
  note: "HIGH: jackpot pools have no exit besides a verified draw and no owner sweep covers them, no update path."
---

## Summary

LuckyStrike lottery. Jackpot draws are verified with Oraclize randomDS; with 3,000 gas the ecrecover fails, so verification fails (OraclizeRandomValueVerificationWasFailed) and the players' jackpot pools are never paid.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01
- __callback 0x27dc297e/0x38bbfa50 emit OraclizeRandomValueVerificationWasFailed on a failed proof; jackpot payout 0xd3f19d5d pays storage_map_au[jackpot] only to the drawn winner
- other exits: withdrawFromMarketingFund (owner, marketing fund only, a separate pot) and 0x3d18b912 (each user's already-credited income); no owner sweep of the jackpot pools and no upgrade
- owner 0x0bba…542f EOA; balance 1.147 ETH; Oraclize cb EOA inactive since before block 20M

## Impact and exposure

- Value held at block 26,438,999: $2,070 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain: the jackpot pools stay locked, no owner/admin sweep reaches them.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
