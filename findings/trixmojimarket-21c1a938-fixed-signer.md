---
id: trixmojimarket-21c1a938-fixed-signer
title: "TrixmojiMarket: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x21c1a938d06f87a039abfc48d1ccb459f55b1685"
  family: "aac9d7f87ce8133e1824abd12e3ae6d5"
  name: "TrixmojiMarket"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 18
  last_active: 2026-11-09
  recoveries_14d: 1
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
  note: "No update path; the signed function dies, but every escrowed item and credit leaves by its owner's direct call, so nothing is locked: MEDIUM."
---

## Summary

TrixmojiMarket: buy and startAuction need an EIP-712 approval signed by `immutable verifier` 0x5f5d219c… (today a 7702-delegated EOA, not real code). If it takes real code, buying and new auctions die. Sellers still cancel() and withdraw their ethscriptions directly, running auctions bid and settle with no signature, and withdraw(credits) needs none.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TrixmojiMarket approval: signed by `verifier`, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TrixmojiMarket.sol:15,87: verifier immutable, set in the constructor; there is no owner and no setter.
- verifier() code = 0xef0100… (a delegation, not real code) (cast code).
- cancel(), bid(), settle(), withdraw() contain no signature check (source).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 18 transactions called it in the 90 days before that block; last on 2026-11-09.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new market; sellers cancel and relist.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
