---
id: mergedadapterwithroundsweethv2-e439ff53-fixed-signer
title: "MergedAdapterWithRoundsWeethV2: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe439ff53e6d8d238f369ba1cb36b1cfbea425bd9"
  family: "d5104dea15cf7b704a25f964f252e7d4"
  copies: 2
  name: "MergedAdapterWithRoundsWeethV2"
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

RedStone weETH-with-rounds price-feed adapter (threshold 3 of a fixed list), no setter, direct deployment. Holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MergedPriceFeedAdapterWithRoundsPrimaryProd via RedstoneAdapterBase: getAuthorisedSignerIndex over fixed list (dossier source)
- facts.json: setters=[], upgrades=[]
- cast call getUniqueSignersThreshold()==3 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new adapter with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
