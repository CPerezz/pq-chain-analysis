---
id: game-656db34f-fixed-gas-recovery
title: "Game: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x656db34fd512fb22ce16bbc621c58394ebb823c4"
  family: "3506ea2115157e22235a163e82b13159"
  copies: 3
  name: "Game"
  upgradeable: "no"
  rating: HIGH
  value_usd: 90
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (redeploy); players cannot act"
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
  note: "HIGH: the admin exits are blocked while bets exist, and only the callback clears bets, so players' stakes are locked. The admin-exit MEDIUM reading misses onlyNoBets."
---

## Summary

EtheRate Game: round 1 has 5 bets (0.05 ETH of players' money). The bank pays out only in play() from __callback, which requires the proof to pass. withdrawAllWei and thisIsTheEnd are onlyNoBets, and only play() resets GP_amountBets.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- GP_amountBets=5, AP_nowRoundBankBalanceWei=0.05 ETH, commission/donate buckets 0, statusGame 1, balance 0.0501 ETH at block 26438999 [cast call/balance]
- withdrawAllWei and thisIsTheEnd carry the onlyNoBets modifier (require GP_amountBets==0); GP_amountBets resets only in play() [sourcify source L1374-1393, L1611-1621]
- __callback: require(proofVerify__returnCode==0) before play(); withdrawTotalBalanceCommission/DonateWei move only those buckets (0) [source L1660-1667, L1311-1322]

## Impact and exposure

- Value held at block 26,438,999: $90 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy. The 0.05 ETH round bank is unrecoverable.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
