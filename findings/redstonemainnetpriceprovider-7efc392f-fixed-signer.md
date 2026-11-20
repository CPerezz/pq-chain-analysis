---
id: redstonemainnetpriceprovider-7efc392f-fixed-signer
title: "RedstoneMainnetPriceProvider: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7efc392f66af226903f8952dce674f15c24b560a"
  family: "80ef3420213f9fb10e4e0330cb03f647"
  name: "RedstoneMainnetPriceProvider"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator (deploy a new provider)"
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
  note: "Oracle feed, no update path, nothing locked: MEDIUM."
---

## Summary

Metronome RedstoneMainnetPriceProvider: the signers are RedStone PrimaryProd constants, with no setter and no upgrade path. If the signers took code, price reads would fail. The provider holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone: the recovered address is looked up in getAuthorisedSignerIndex, a list of addresses fixed in the adapter's code; a threshold of distinct signers is needed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: RedstonePriceProvider is PrimaryProdDataServiceConsumerBase, with constant getAuthorisedSignerIndex
- state.json at block 26438999: no proxy slots, balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new provider and repoint the consumer oracle to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
