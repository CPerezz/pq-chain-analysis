---
id: bonusroll-46403e94-fixed-gas-recovery
title: "BONUSROLL: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x46403e94529fc04d04c9c393beab1d050ef06409"
  family: "ec48e906d326987fa6d024a17429964a"
  name: "BONUSROLL"
  label: "Fortunity"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 41467
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner takes the balance with takeAll before activation"
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
  rating: MEDIUM
  note: "raffle stops from day one; owner takeAll is the way out; dormant"
---

## Summary

`BONUSROLL` at `0x46403e94529fc04d04c9c393beab1d050ef06409`. Its Oraclize random-proof check gives ecrecover 3,000 gas, so no raffle starts from activation day; the owner can take the whole balance without a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: every valid signature fails: the code gives the precompile 3,000 gas. Bytecode.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: __callback runs oraclize_randomDS_proofVerify, whose ecrecover gets a constant 3,000 gas; on failure it retries twice and then stops, so no raffle starts.
- takeAll() (onlyOwner) sends the whole balance to the owner; no signature needed.
- No proxy, no upgrade. No transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $41,467 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws with takeAll and stops the game.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
