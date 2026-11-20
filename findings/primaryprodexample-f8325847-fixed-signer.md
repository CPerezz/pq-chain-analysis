---
id: primaryprodexample-f8325847-fixed-signer
title: "PrimaryProdExample: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf8325847c7c80e51449d3a7b4a83d3ddeca05abf"
  family: "69c7f49acad7496f48165dc4b62436e3"
  name: "PrimaryProdExample"
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

RedStone primary-prod example: getAuthorisedSignerIndex over a fixed 5-signer list (threshold 5), no setter. Example contract, holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PrimaryProdDataServiceConsumerBase.sol:12,16: getUniqueSignersThreshold/getAuthorisedSignerIndex over fixed list (dossier source)
- facts.json constants: 5 RedStone addresses, code_bytes=0
- txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Not production-relevant; redeploy with fresh signers if it were.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
