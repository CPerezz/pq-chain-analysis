---
id: pricefeedsadapterswellwithrounds-9a90445b-fixed-signer
title: "PriceFeedsAdapterSwellWithRoundsV4: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x9a90445b8e05293368f66cf1f7874e3f24d2a392"
  family: "527a0a43f59a39f899128adf520f53f3"
  name: "PriceFeedsAdapterSwellWithRoundsV4"
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
  note: "No update path, no funds held by design -> MEDIUM."
---

## Summary

RedStone Swell price-feed adapter: getAuthorisedSignerIndex checks a hard-coded signer list (threshold 2), no setter, not a proxy at this address. Holds no funds; a broken signer set just stops price updates.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PriceFeedsAdapterSwellWithRounds.sol:18,33: getUniqueSignersThreshold=2, getAuthorisedSignerIndex over a fixed list (dossier source)
- cast storage slot 0 == 0 at block 26438999; no EIP-1967 impl slot set
- facts.json: eth_at_pinned_block likely 0 (oracle adapter, no value fields)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new adapter with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
