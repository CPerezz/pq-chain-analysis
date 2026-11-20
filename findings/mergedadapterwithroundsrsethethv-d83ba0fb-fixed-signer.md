---
id: mergedadapterwithroundsrsethethv-d83ba0fb-fixed-signer
title: "MergedAdapterWithRoundsRsethethV1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd83ba0fba552862d679d77d074e01cdf259f7a4f"
  family: "4a78aa9e82ed2b96b3de5263561012f1"
  copies: 4
  name: "MergedAdapterWithRoundsRsethethV1"
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

RedStone rsETH-with-rounds price-feed adapter (threshold 2 of a fixed list), no setter, direct deployment. Holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MergedPriceFeedAdapterWithRoundsPrimaryProd via RedstoneAdapterBase: getAuthorisedSignerIndex over fixed list (dossier source)
- facts.json: setters=[], upgrades=[]
- facts.json: eth_at_pinned_block not applicable (oracle adapter, no balance fields present)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new adapter with fresh signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
