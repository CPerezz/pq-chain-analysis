---
id: pricefeedcompressor-1ad57cd3-fixed-signer
title: "PriceFeedCompressor: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1ad57cd3b584dfeb6c28239a0ff4d8a040de82b7"
  family: "2234e632d260a52d82a945f32f83caab"
  copies: 2
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

A Gearbox PriceFeedCompressor (solc 0.8.23): a view-only aggregator with no ecrecover. It reads RedStone feed getters through a serializer created in its constructor.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dossier source compressors/PriceFeedCompressor.sol:94 `new RedstonePriceFeedSerializer()`; the serializer only calls signerAddressN/lastPrice getters
- scanner.json: 22 STATICCALLs, no constant target (none to 0x01)
- heimdall decompile (scratch oracles/0x1ad57cd3…/decompiled.sol): 0 occurrences of ecrecover; code.hex does not contain the RedStone signer keys
- txs_90d 0; value_usd null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
