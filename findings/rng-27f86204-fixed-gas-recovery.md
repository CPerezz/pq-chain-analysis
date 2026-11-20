---
id: rng-27f86204-fixed-gas-recovery
title: "RNG: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x27f86204b9280a5b77c9f6d013555c867aba9a6c"
  family: "434ef7265a696a2b913c93abc4b0193c"
  name: "RNG"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0x97465528… (EOA)"
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
  rating: LOW
  note: "LOW: a setting avoids the broken path"
---

## Summary

RNG service for lotteries: the Oraclize random-DS proof (3000-gas safer_ecrecover) fails, so the Oraclize callback rejects every result.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- RNG.sol (Oraclize API) safer_ecrecover with call(3000, 1, …); __callback at line 1423 checks proofVerify__returnCode
- RNG.sol:1470 setUseOraclize(bool) and 1474 setRandao(address) are onlyOwner: switch to Randao
- RNG.sol:1461 withdraw(address,uint256) is onlyOwner; owner 0x974655285b84a7042513b99714e3907991ab7aab is an EOA; balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setUseOraclize(false) to use Randao.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
