---
id: dex2-7600977e-signed-shortcut-lost
title: "Dex2: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x7600977eb9effa627d6bd0da2e5be35e11566341"
  family: "3072037f7cf1e581e685c36ee14d7d74"
  copies: 5
  name: "Dex2"
  label: "DEx.top"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 299196
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-20
fix:
  layer: none
  who_acts: "the admin / trader"
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
  note: "no path to make an order without a signature: trading dies for a maker whose address holds code, but deposits leave by direct withdraw, so nothing is locked → MEDIUM (scale: the function dies, nothing locked, no update path) (withdrawals depend on the admin, not on a signature). Flagged."
---

## Summary

DEx.top Dex2: the admin submits order sequences; each new order must be signed by its trader; a trader with code cannot place orders.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Dex2 order: the trader named in the order must have signed it. Read from source.
- Dex2.sol:551-563 parseNewOrder: traderAddr must equal ecrecover; the only ecrecover in the contract
- Dex2.sol:261 exeSequence is admin-only; withdrawals are initiated there with no trader signature (initiateWithdraw, :285/403) and paid by withdrawEth/withdrawToken (:194/213)
- admin() = 0xfd2d9110…8b1f at block 26438999 (state.json)

## Impact and exposure

- Value held at block 26,438,999: $299,196 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-20.

## Remediation

Code-holding traders withdraw through the admin; they cannot trade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
