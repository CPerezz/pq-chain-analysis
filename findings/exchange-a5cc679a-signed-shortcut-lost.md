---
id: exchange-a5cc679a-signed-shortcut-lost
title: "Exchange: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa5cc679a3528956e8032df4f03756c077c1ee3f4"
  family: "d76ef8bbe63074dd432006525e0a0c8f"
  name: "Exchange"
  label: "EtherMium"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 10647
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6
  last_active: 2026-11-14
fix:
  layer: none
  who_acts: "user with code (withdraws directly)"
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
  rating: MEDIUM
  note: "LOW does not hold: there is no direct path for trading. Nothing is locked (direct withdraw), so MEDIUM: the function dies but nothing is locked. Value $10647, txs_90d 6 (not rating inputs)."
---

## Summary

Ethermium Exchange (IDEX-style): trade, cancelOrder and adminWithdraw are admin-only and need the user's ECDSA signature. A user whose address has code can no longer trade or cancel; its funds still leave by a direct withdraw after the inactivity period.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: IDEX-style adminWithdraw (variant): the user named must have signed / IDEX-style trade (variant): maker and taker must each have signed / IDEX-style cancelOrder (variant): the maker must have signed…. Read from source.
- source Exchange.sol: trade(...) onlyAdmin requires ecrecover(makerOrderHash)==maker and the same for the taker; cancelOrder is onlyAdmin with ecrecover==user; no on-chain order function
- withdraw(token, amount) is a direct msg.sender call, allowed once block.number - lastActiveTransaction >= inactivityReleasePeriod
- no upgrade path (row upgradeable=no)

## Impact and exposure

- Value held at block 26,438,999: $10,647 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

The user withdraws directly after the inactivity period; trading for that user can't be restored.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
