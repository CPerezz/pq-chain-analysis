---
id: e35f2447-fixed-gas-recovery
title: "0xe35f2447: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0xe35f24470730f5a488da9721548c1ab0b65b53d5"
  family: "d39bccb3d86d347c15d62336c37696b5"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "bot owner 0x4696875e2e28d2eE896f6167e93668Fd7D3114Ee"
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
  note: "the bot's own function stops for good (the gas is a code constant), but funds leave by owner withdraw: nothing locked"
---

## Summary

Ownable MEV/swap bot: swap() 0x8119c065 executes a payload only if it was signed by the stored signer. Recovery is a STATICCALL to 0x01 with 3000 gas, so every call reverts after activation; the owner can still withdraw without a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x697-0x6a0: PUSH1 0x01, PUSH2 0x0bb8, STATICCALL; then `require(var_b == signer)` in 0x8119c065
- signer() = 0x8FE3d900086214fB71817be7f9C90fb6bF6FB819 (EOA, settable by setSigner, onlyOwner); owner() = 0x4696...14Ee (EOA)
- way out: 0xf3fef3a3(address,uint256) sends ETH and 0x061e37a3 sweeps ERC20s, both onlyOwner with no signature
- balance 999 wei at block 26438999; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws the dust and redeploys the bot with an uncapped ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
