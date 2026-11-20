---
id: hamsterhour-e33ab493-fixed-signer
title: "HamsterHour: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe33ab493249a2df0d8c4a71ac54f46d1f7778367"
  family: "a0e2759b9413c532c5efd396e3b717b9"
  name: "HamsterHour"
  label: "deployed by moneycanbuy.fun: Deployer"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 1084
  last_active: 2026-11-11
  recoveries_14d: 17
fix:
  layer: new-deployment
  who_acts: "none on chain; team can only redeploy"
evidence:
  level: executed
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
  verdict: confirmed
  rating: HIGH
  note: "No update path, and the jackpot (users' fees and donations) has no exit, so HIGH. Bets themselves are refunded through timeout."
---

## Summary

HamsterHour settles windows only on results signed by the immutable ATTESTER 0x5598aa91… (no code today). Unsettled windows time out and refund the bets, but the jackpot pool is paid only to winners of a settled window, so it is locked for good.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: HamsterHour: the result must be signed by ATTESTER, fixed in the code. Read from source. Executed: a real transaction loses its effect with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source L63/L541: `address public immutable ATTESTER`, _recordResult reverts unless recover == ATTESTER; ATTESTER() = 0x5598…, which has no code
- timeout() (L600) and claim() refund all binary stakes and tickets on TimedOut windows, so bets are not locked
- _finalizeOne: the jackpot pot carries forward in jackpotSeed and pays out only for Settled windows with winners; onlyTeam functions only schedule line and recipients, with no rescue
- at block 26438999: jackpotSeed = 58.7 IMD, filled from bettors' fees and feedHamster/depositJackpot donors; total IMD held is 363.25

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,084 transactions called it in the 90 days before that block; last on 2026-11-11.
- 17 signature recoveries in the study's two-week trace window.

## Remediation

Redeploy with a new attester; the existing jackpot cannot be recovered.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
