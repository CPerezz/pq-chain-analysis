---
id: signedpriceadapter-ecedc5e0-fixed-signer
title: "SignedPriceAdapter: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xecedc5e05f9bff567f7ad976bd0b35c5be6d348c"
  family: "5317f1d06e22de0f1c9f575cd66b87fe"
  copies: 90
  name: "SignedPriceAdapter"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1196
  last_active: 2026-11-18
  recoveries_14d: 408
fix:
  layer: onchain-config
  who_acts: "consumer hub's Safe (e.g. 0x51bd2a8ddb426e368aa6fc76a6b1c3b3ea57f8c0, 2-of-n Gnosis Safe)"
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
  rating: LOW
  note: "The consumer can swap the source by a setting, so LOW. Only one of the 90 copies' consumers was checked."
---

## Summary

SignedPriceAdapter accepts price reports only from its immutable bot signer, so the adapter is dead once that key has code. Each asset has several signed slots, and the consuming hub's Safe can queue a replacement source.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SignedPriceAdapter: the signer must be `signer`, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: `address public immutable signer`, no setter; signer() = 0x2f30f791…, which has no code
- the traced consumer hub 0xdca18f3e… has a Safe-gated f83b6f34(asset, slot, adapter) source replacement executed after a delay (8ff098f1); safe() = 0x51bd2a8d…, a Gnosis Safe with threshold 2
- the same asset has a second signed slot with a different signer (0x46f9ca9e…, signer 0x5ceb2898…)
- adapter holds no funds

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 90 addresses).
- Activity: 1,196 transactions called it in the 90 days before that block; last on 2026-11-18.
- 408 signature recoveries in the study's two-week trace window.

## Remediation

The hub Safe replaces the adapter with one that has a fresh signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
