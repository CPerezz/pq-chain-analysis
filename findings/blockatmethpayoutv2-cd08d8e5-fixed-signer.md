---
id: blockatmethpayoutv2-cd08d8e5-fixed-signer
title: "BlockATMEthPayoutV2: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248"
  family: "adfd1a789f3797b57604649b2ffabdd1"
  copies: 3
  name: "BlockATMEthPayoutV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 44993
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 97
  last_active: 2026-11-17
  recoveries_14d: 31
fix:
  layer: offchain
  who_acts: "finance accounts pay out by direct call (withdrawByFinancial, to whitelisted addresses)"
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
  rating: LOW
  note: "signed proxy payouts stop; the same payout stays open to finance accounts by direct call, so LOW"
---

## Summary

`BlockATMEthPayoutV2` at `0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248`, with 2 more addresses running its code. Signed proxy payouts need a finance address fixed at construction; finance accounts can still withdraw by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BlockATM payout: a proxy payout needs a signature that recovers to an address of financeMap; the map is filled only at construction (processList) and has no add or remove, so the finance set is…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: a proxy payout needs a signature recovering to an address of financeMap, filled only at construction.
- withdrawByFinancial is callable directly by a finance account (onlyFinance on msg.sender), so funds can leave without ECDSA.
- Executed: a real payout reverts once its signer has code. 97 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $44,993 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 97 transactions called it in the 90 days before that block; last on 2026-11-17.
- 31 signature recoveries in the study's two-week trace window.

## Remediation

Finance accounts pay out directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: re-rated LOW (was MEDIUM the same day): withdrawByFinancial lets a finance account, even one with code, make the same payout to a whitelisted address by direct call, so the act stays open (D-025).
