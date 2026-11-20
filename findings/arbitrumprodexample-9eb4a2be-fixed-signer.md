---
id: arbitrumprodexample-9eb4a2be-fixed-signer
title: "ArbitrumProdExample: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9eb4a2be80abcaa9d6135041244b2327d09892d8"
  family: "5595fa7c30f99d9c7dfa91f32378fe75"
  name: "ArbitrumProdExample"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "RedStone (no owner action; feed just stalls)"
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
  note: "No update path, no funds by design -> MEDIUM."
---

## Summary

RedStone Arbitrum-prod demo consumer: getAuthorisedSignerIndex checks a fixed 5-signer list, threshold 5 (all must sign), no setter. Demo/example contract, holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ArbitrumProdDataServiceConsumerBase.sol:12,16: getUniqueSignersThreshold/getAuthorisedSignerIndex over fixed list (dossier source)
- facts.json constants list 5 RedStone addresses, all code_bytes=0 per facts
- txs_90d=0, not a proxy (direct deployment per facts how_addresses_come_to_run_it)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Not production-relevant; if it were, redeploy with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
