---
id: trixmojimarket-d935e162-fixed-signer
title: "TrixmojiMarket: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd935e162b6070c4feaf600c67f7f729f318515a2"
  family: "9548dc30408db4cf28d9356a6c648e22"
  name: "TrixmojiMarket"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 10
  last_active: 2026-11-04
fix:
  layer: new-deployment
  who_acts: "sellers/buyers"
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
  rating: MEDIUM
  note: "The signed function dies with nothing locked: MEDIUM."
---

## Summary

Earlier TrixmojiMarket build (it lacks the deposit-and-list fallback). Same verifier 0x5f5d219c…, immutable, gating buy and startAuction. cancel, bid, settle and withdraw need no signature, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TrixmojiMarket approval: signed by `verifier`, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Diff against 0x21c1a938…: only the fallback deposit-and-list branch differs; _approve and verifier are identical (source).
- verifier()=0x5f5d219c…, code 0xef0100… (delegation); balance 0 ETH (cast).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

Deploy a new market; sellers cancel.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
