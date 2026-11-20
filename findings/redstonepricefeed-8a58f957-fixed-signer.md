---
id: redstonepricefeed-8a58f957-fixed-signer
title: "RedstonePriceFeed: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8a58f957b99e1ed6b3df20f267a6d5a6dd8e3513"
  family: "05bb8f69a0bcae553dfaa3bcddcd0e74"
  copies: 10
  name: "RedstonePriceFeed"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the consumer's configurator swaps the price feed"
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
  note: "The feed's signers are immutable, but a Gearbox feed is consumed through the price oracle, whose configurator replaces a feed by a setting (as for 0x0d5d2f70, already swapped out): LOW. The feed itself holds nothing."
---

## Summary

Gearbox RedstonePriceFeed: the signer addresses are immutables set at construction, checked in getAuthorisedSignerIndex, with no setter. If enough signers took code, updatePrice would stop working. The feed holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: getAuthorisedSignerIndex compares the signer with immutables signerAddress0..9; no setter
- state.json at block 26438999: no proxy slots, balance 0
- scanner: one STATICCALL to 0x01 (pc 5979/6578)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 10 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new feed and repoint the Gearbox PriceOracle to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
