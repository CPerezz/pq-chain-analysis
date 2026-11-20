---
id: pricefeedsadapterswell-a2db01bb-signer-upgrade-only
title: "PriceFeedsAdapterSwell: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa2db01bbfe8e1eed8c0ac4c92d0bb76c5fee9d0f"
  family: "53cc62cfb65e680bfc9802d028fd66d5"
  copies: 2
  name: "PriceFeedsAdapterSwell"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "n/a"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "p_impl != row address: the row's implementation has been upgraded away; whatever issue it had is moot since nothing delegates to it now — refuted."
---

## Summary

RedStone PriceFeedsAdapterSwell: the live proxy for this dossier's representative (0x94329d3bd980a67e5b799e25faa6522eebac0d13) currently points to implementation 0xeb9cdd70f7a6827808595394fb4f2d22394c34b2, not to this row's address — this row's code has already been replaced and is not what is live there.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- node, block 26438999: proxy 0x94329d3bd980a67e5b799e25faa6522eebac0d13, eip1967 implementation = 0xeb9cdd70f7a6827808595394fb4f2d22394c34b2 (≠ row address 0xa2db01bb...), admin = ProxyAdmin 0x8223a627... owned by the same live 2-of-3 Safe 0x6906F3a0... as 0x8d6d4... in this batch
- batch facts: this row's own address has implementation=null, setters=[], upgrades=[] (it is the old, superseded standalone implementation)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a — superseded code, not live.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
