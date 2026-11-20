---
id: mergedadapterwithouthroundsethxe-4c9add2c-fixed-signer
title: "MergedAdapterWithouthRoundsEthxethV1: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x4c9add2cea4a79fc6f50da0068a0cf8368c4248b"
  family: "6ec1d573126fad27e16440a6fbb151bd"
  name: "MergedAdapterWithouthRoundsEthxethV1"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  note: "Rule: an uninitialized implementation is refuted. Not checked: which proxies point to it. eth_getLogs for Upgraded is impossible because the node is down."
---

## Summary

MergedAdapterWithouthRoundsEthxethV1 is a RedStone price-feed adapter implementation, and it was never initialized. It inherits OZ v4 Initializable, and slot 0 (_initialized) is 0 at block 26438999.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: PriceFeedsAdapterBase is RedstoneAdapterBase, Initializable (OZ v4, uint8 _initialized in slot 0)
- state.json at block 26438999: slot_0 = 0, EIP-1967 slots empty, balance 0
- facts.json: no recovery in the traced window; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
