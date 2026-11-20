---
id: liquiditytransformer-c2a4705e-fixed-gas-recovery
title: "LiquidityTransformer: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xc2a4705ecc9dab55dcc9432c7530731321490323"
  family: "02767e1e1591e7362cd896095b2c22dd"
  name: "LiquidityTransformer"
  label: "deployed by SWAPP Protocol: Deployer"
  upgradeable: "no"
  rating: NONE
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
  note: "Refuted: the random phase is finished and there are no funds. Neither the __timeout LOW nor the operator-path MEDIUM applies, because the callback is never needed again."
---

## Summary

SWAPP LiquidityTransformer (Wise fork): the random draw only sets daily supply. All funded days are generated and the liquidity is forwarded (totalWeiContributed 0). ETH balance is 0. The proof path is unreachable.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- g() at block 26438999 = (generatedDays 30, buffer 0, timeout 0, preparedReferrals 0, totalTransferTokens 0, totalWeiContributed 0, totalReferralTokens 0) [cast call]
- ETH balance 0 at block 26438999 [cast balance]
- requestTeamFunds: no caller check, but it pays only the constant TEAM_ADDRESS 0xde121Cc7... and is gated by afterUniswapTransfer (generatedDays>0 && totalWeiContributed==0); both 'flags' are now satisfied [sourcify source L1447-1454, L1359]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
