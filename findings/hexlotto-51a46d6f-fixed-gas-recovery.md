---
id: hexlotto-51a46d6f-fixed-gas-recovery
title: "HEXLOTTO: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x51a46d6f029bd7da36b16ea78baca80b2c447059"
  family: "b2af0ab7ce415ca5553a0c5b6b07f877"
  name: "HEXLOTTO"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody can recover the pot; owner 0x285ee70c… can only change parameters"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "HIGH: users' ticket pots (42000 HEX plus dust ETH), no update path and no way out"
---

## Summary

HEXLOTTO: Provable random-DS lottery; __callback needs provable_randomDS_proofVerify__returnCode == 0, and safer_ecrecover's 3000-gas call fails, so every draw reverts and the ticket pots are never paid out.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- HEXLOTTO.sol:1271 `call(3000, 1, 0, size, 128, size, 32)` in safer_ecrecover; verifySig compares keccak(pubkey) with the result
- HEXLOTTO.sol:2093-2099 __callback reverts 'Proof verification failed.'; winners are paid only in pick*Winner, called from __callback
- owner functions are only setGasAmounts/setTicketPrice/setMinimumPot/ownership; no withdraw of the pot; owner 0x285ee70c… is an EOA
- HEX token (0x2b591e99…) balanceOf(this) at block 26438999 = 4.2e12 (8 decimals = 42000 HEX), the actual locked pot; native balance 0.0011 ETH, value_usd 2; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain: the pot stays locked; a new lottery would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
