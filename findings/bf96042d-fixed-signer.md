---
id: bf96042d-fixed-signer
title: "0xbf96042d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbf96042d61937b1686b81557c3a92806f1727ecf"
  family: "53708593f2063a9e50f3ee6ab2a73a16"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 25838
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the COO refunds open bets and the CFO withdraws"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "bets stop; refunds and withdrawals stay"
---

## Summary

Contract `0xbf96042d61937b1686b81557c3a92806f1727ecf`. A dice game whose bets need a signature of one stored signer; a signer with code stops new bets, but open bets can be refunded and the bankroll withdrawn by direct calls.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: one stored signer; all 21 selectors named and none replaces it. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompiled (heimdall): placing a bet checks a signature against a stored signer with no setter.
- refundBet (COO only), settleBet (COO only), withdrawBalance (CFO only) and kill (CEO only) need no signature; setCEO, setCFO and setCOO replace those roles.
- No proxy, no upgrade. Dormant.

## Impact and exposure

- Value held at block 26,438,999: $25,838 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The COO refunds open bets; the CFO withdraws.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
