---
id: erc7412redstonefeed-993b33f7-fixed-signer
title: "ERC7412RedstoneFeed: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x993b33f7bdd6b60fa3b09e4cf32c72868cce3c82"
  family: "e2dab1d021932378639b33ee6a8ba90d"
  name: "ERC7412RedstoneFeed"
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
  note: "No update path and the feed holds no money by design -> MEDIUM."
---

## Summary

Synthetix ERC-7412 RedStone feed: getAuthorisedSignerIndex checks a fixed 5-address list with a 3-of-5 threshold, no setter, no proxy at this address. The feed itself holds no funds; if signers get code, getLatestValue/updateDataFeedsValues stop updating this price feed.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ERC7412RedstoneFeed.sol:38-55: getAuthorisedSigners() returns 5 hard-coded addresses, threshold 3, no setter (dossier source)
- state.json/cast storage at block 26438999: EIP-1967 impl/admin slots and slot 0-2 all zero -- not a proxy
- facts.json: eth_at_pinned_block=0, addresses_with_eth=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new feed adapter with fresh signers; downstream consumers repoint to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
