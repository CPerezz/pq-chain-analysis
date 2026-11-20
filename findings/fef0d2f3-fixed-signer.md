---
id: fef0d2f3-fixed-signer
title: "0xfef0d2f3 (tagged deployed by Wise: Deployer): signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xfef0d2f3a79b4338d8418003dd9df89281242063"
  family: "282894bb13f9f0bf91c1179f2c5838f3"
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
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
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

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
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

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
