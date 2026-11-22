---
id: 656db34f-fixed-signer
title: "0x656db34f: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x656db34fd512fb22ce16bbc621c58394ebb823c4"
  family: "3506ea2115157e22235a163e82b13159"
  copies: 3
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
  verdict: confirmed
  rating: HIGH
  note: "HIGH: the admin exits are blocked while bets exist, and only the callback clears bets, so players' stakes are locked. The admin-exit MEDIUM reading misses onlyNoBets."
---

## Summary

EtheRate Game: round 1 has 5 bets (0.05 ETH of players' money). The bank pays out only in play() from __callback, which requires the proof to pass. withdrawAllWei and thisIsTheEnd are onlyNoBets, and only play() resets GP_amountBets.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
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

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
