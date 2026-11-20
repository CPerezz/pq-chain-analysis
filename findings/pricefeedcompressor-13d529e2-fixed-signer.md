---
id: pricefeedcompressor-13d529e2-fixed-signer
title: "PriceFeedCompressor: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x13d529e2dc67a6305580388a7c57de53fbefc951"
  family: "0d2bfcfbcadbe97c33bca343eb53dd36"
  name: "PriceFeedCompressor"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
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
  note: "Misattributed: no ecrecover in the code. Refuted."
---

## Summary

An older Gearbox PriceFeedCompressor (solc 0.8.17): a view-only aggregator with no ecrecover. RedStone feeds are only read through RedstonePriceFeedSerializer getters.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dossier source compressors/PriceFeedCompressor.sol:70 creates RedstonePriceFeedSerializer with `new`; no updatePrice or RedstoneConsumer inheritance in contracts/
- scanner.json: 19 STATICCALLs, no constant target (none to 0x01)
- heimdall decompile (scratch oracles/0x13d529e2…/decompiled.sol): 0 occurrences of ecrecover; code.hex does not contain the RedStone signer keys
- txs_90d 0; value_usd null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
