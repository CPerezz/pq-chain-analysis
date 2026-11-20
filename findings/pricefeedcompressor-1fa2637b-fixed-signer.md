---
id: pricefeedcompressor-1fa2637b-fixed-signer
title: "PriceFeedCompressor: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1fa2637b9fab0cd14290a7ee908ddc9688a15120"
  family: "c0ca6138cb913803aabc67b35b7024b2"
  name: "PriceFeedCompressor"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-08-21
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
  note: "Misattributed: the code has no ecrecover. It pulled in the RedStone library only for types. Refuted."
---

## Summary

Gearbox periphery PriceFeedCompressor: a view-only aggregator that never calls ecrecover. It only reads getters (signerAddressN, lastPrice) of RedStone feeds through a RedstonePriceFeedSerializer, so the row's RedStone signer check is not in this code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dossier source compressors/PriceFeedCompressor.sol and serializers/oracles/RedstonePriceFeedSerializer.sol: RedstonePriceFeed is only cast to read getters; serializers are created with `new` in the constructor (init code), no RedstoneConsumerBase in the runtime
- scanner.json: 34 STATICCALLs with targets from calldata/returndata/memory and one constant target 0xf7f0a609…; none to precompile 0x01
- code.hex does not contain the RedStone signer 0x8bb8f32d… (the Gearbox RedstonePriceFeed code.hex does)
- txs_90d 1, last_active 2026-08-21; value_usd null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-21.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
