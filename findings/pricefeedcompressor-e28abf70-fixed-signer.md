---
id: pricefeedcompressor-e28abf70-fixed-signer
title: "PriceFeedCompressor: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xe28abf7028c059c4ebbe726aea7c2ef3f429b02d"
  family: "1ab6fe3398936c2b9466c8c6a2d1db64"
  copies: 2
  name: "PriceFeedCompressor"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "Misattributed, same reasoning as the other PriceFeedCompressor copy."
---

## Summary

PriceFeedCompressor is a read-only aggregator: getPriceFeeds/_getPriceFeedTreeNode STATICALLs other oracle contracts to read already-validated values (e.g. a RedstonePriceFeed's lastPrice()/signerAddress0..9, read only for display/serialization). It performs zero ecrecover calls itself. Same PriceFeedCompressor.sol as the e26c1864 copy.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts.json: n_ec=0 for this address's bytecode
- same source file (PriceFeedCompressor.sol) and class as the other PriceFeedCompressor row in this batch
- scanner.json: no ecrecover-flagged call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
