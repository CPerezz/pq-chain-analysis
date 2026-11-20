---
id: pricefeedcompressor-e26c1864-fixed-signer
title: "PriceFeedCompressor: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xe26c1864b5d3cc2e541e19c3473caed5d34bc3bf"
  family: "d06b4d10950c0f7bdc88788b59edef5f"
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
  note: "Misattributed: this address runs zero ecrecover calls; the real RedStone check lives in the separate feed contracts it reads from."
---

## Summary

PriceFeedCompressor is a read-only aggregator: getPriceFeeds/_getPriceFeedTreeNode STATICALLs other oracle contracts to read already-validated values (e.g. a RedstonePriceFeed's lastPrice()/signerAddress0..9, read only for display/serialization). It performs zero ecrecover calls itself.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts.json: n_ec=0 for this address's bytecode
- scanner.json: every call is a STATICCALL with a calldata/memory/storage target, none flagged ecrecover
- PriceFeedCompressor.sol / RedstonePriceFeedSerializer.sol: only calls pf.signerAddress0()..signerAddress9() as view getters, never verifies a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
