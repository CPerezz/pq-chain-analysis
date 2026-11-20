---
id: sneakerheadsxmagpark-593d2af5-fixed-signer
title: "SneakerHeadsxMagPark: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x593d2af58aeca16d387cea55ae96c3aa132a023f"
  family: "75c2b215aa29c7b7468c71eb6c57b4b6"
  name: "SneakerHeadsxMagPark"
  label: "Sneaker Heads x Mag Park: SHMG Token"
  upgradeable: "no"
  rating: NONE
  txs_90d: 3
  last_active: 2026-10-20
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
  note: "The only path that reaches the check is closed for good by time, so refuted."
---

## Summary

SneakerHeadsxMagPark (Helmets2117 idiom): mint() is the only signed path (constant SIGNER_ADDRESS 0xFc8931C9…), and it reverts with SalesHaveEnded once block.timestamp >= SALES_END_TIME (1674216000, 2023-01-20), a constant.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source SneakerHeadsxMagPark.sol: SALES_END_TIME constant 1674216000; getCurrentSaleStage returns ENDED after it; mint reverts on ENDED before _isTrustedSigner
- _isTrustedSigner is used only by mint()
- signer 0xfc8931c9… has no code, nonce 0; contract holds 0 ETH; withdrawMoney is onlyManager

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-10-20.

## Remediation

None needed: the sale window closed for good in January 2023.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
