---
id: liquiditytransformer-fef0d2f3-fixed-gas-recovery
title: "LiquidityTransformer: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xfef0d2f3a79b4338d8418003dd9df89281242063"
  family: "282894bb13f9f0bf91c1179f2c5838f3"
  name: "LiquidityTransformer"
  label: "deployed by Wise: Deployer"
  upgradeable: "no"
  rating: NONE
  value_usd: 1204
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: the proof check is unreachable now (all days generated, liquidity forwarded), so nothing changes on activation. The __timeout-based LOW argument does not hold (a failed callback zeroes generationTimeout), but it is moot."
---

## Summary

Wise LiquidityTransformer: the random draw only sets each investment day's supply. All 50 days were already generated and the liquidity was forwarded, so the callback can never be needed again. ETH balance is 0.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- g() at block 26438999 = (generatedDays 50, generationDayBuffer 0, generationTimeout 0, preparedReferrals 2155, totalTransferTokens 0, totalWeiContributed 0, totalReferralTokens 0) [cast call]
- generateSupply requires dailyTotalSupply[day]==0; the random query is only sent from _generateRandomSupply [sourcify source L1679-1753]
- requestTeamFunds has no caller check but only pays the constant TEAM_ADDRESS, gated by afterUniswapTransfer (generatedDays>0 && totalWeiContributed==0); balance 0 [source L2348-2355, cast balance]
- __timeout() exists, but a delivered failed proof resets generationTimeout=0, so it is not a reliable bypass (moot here) [source L1789-1790, L1841-1848]

## Impact and exposure

- Value held at block 26,438,999: $1,204 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed: the contract is past its random phase.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
