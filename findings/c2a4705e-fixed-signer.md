---
id: c2a4705e-fixed-signer
title: "0xc2a4705e (tagged deployed by SWAPP Protocol: Deployer): signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc2a4705ecc9dab55dcc9432c7530731321490323"
  family: "02767e1e1591e7362cd896095b2c22dd"
  label: "deployed by SWAPP Protocol: Deployer"
  upgradeable: "no"
  rating: NONE
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
  note: "Refuted: the random phase is finished and there are no funds. Neither the __timeout LOW nor the operator-path MEDIUM applies, because the callback is never needed again."
---

## Summary

SWAPP LiquidityTransformer (Wise fork): the random draw only sets daily supply. All funded days are generated and the liquidity is forwarded (totalWeiContributed 0). ETH balance is 0. The proof path is unreachable.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
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

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
