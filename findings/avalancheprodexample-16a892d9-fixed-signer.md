---
id: avalancheprodexample-16a892d9-fixed-signer
title: "AvalancheProdExample: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x16a892d95350dc60cabed136070fc6fbefbb1b80"
  family: "126b5b5eacec81cb5055a7c1197dd557"
  name: "AvalancheProdExample"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "its deployer (0x89fE6Ba3…), if anyone uses it"
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
  note: "Oracle feed / view helper, nothing held, no update path → MEDIUM by mechanism (RedStone precedent). It is a demo with no known consumer, which does not lower the rating."
---

## Summary

A RedStone demo contract (AvalancheProdExample): only view functions that return a price from signed calldata, with 5 hardcoded redstone-avalanche-prod signer keys (threshold 5). It has no storage, holds nothing and has no dependants.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source contracts/AvalancheProdExample.sol: getLatestPrice / getLatestPricesForManyAssets are `view` and call getOracleNumericValue(s)FromTxMsg; threshold 5; imports hardhat/console.sol (an example build)
- AvalancheDataServiceConsumerBase: constant keys 0x1eA62d73…, 0x2c596172…, 0x12470f7a…, 0x109B4a31…, 0x83cbA8c6…; all 5 have no code (publicnode, latest, block ~26452937)
- facts.json: no code holds or calls its address; 1 address runs the code; no proxy; txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed; a user of the demo would deploy a new consumer

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
