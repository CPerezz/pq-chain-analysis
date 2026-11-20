---
id: blockatmethpayoutv2-cd08d8e5-signed-shortcut-lost
title: "BlockATMEthPayoutV2: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcd08d8e570378ddb48dd5f7a5a0b702ddaa7e248"
  family: "adfd1a789f3797b57604649b2ffabdd1"
  copies: 3
  name: "BlockATMEthPayoutV2"
  upgradeable: "no"
  rating: LOW
  value_usd: 44934
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 97
  last_active: 2026-11-17
  recoveries_14d: 31
fix:
  layer: offchain
  who_acts: "the finance accounts"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $44934, txs_90d 97."
---

## Summary

BlockATM ETH payout: proxy payouts need a signature from a finance address; under EIP-8151 a finance account with code loses the signed route.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: BlockATM payout: a proxy payout needs a signature that recovers to an address of financeMap; the map is filled only at construction (processList) and has no add or remove, so the finance set is…. Read by hand. Executed: a real transaction reverts with code at the signer.
- payoutByProxy: digest.recover(signature) must be in financeMap (BlockATMEthPayoutV2.sol:1649, 1740-1741)
- withdrawByFinancial(bool,address,address,uint256) is onlyFinance on msg.sender (1513; modifier at 57-59)
- A finance account with code keeps the direct call; no setter needed

## Impact and exposure

- Value held at block 26,438,999: $44,934 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 97 transactions called it in the 90 days before that block; last on 2026-11-17.
- 31 signature recoveries in the study's two-week trace window.

## Remediation

Finance accounts call withdrawByFinancial directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
