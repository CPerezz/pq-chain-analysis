---
id: wagies-0561c497-signer-upgrade-only
title: "Wagies: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0561c497a190b876b524e8df3c0403a828269342"
  family: "51a2d51bd26627928e1699ed6de21c5d"
  copies: 2
  name: "Wagies"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: bytecode
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
  note: "Refuted per the main reviewer's rule (2026-11-20): an implementation with no live proxy found and no state of its own. Its own ETH balance could not be read (node timeout); the proxy search was stopped to spare the node."
---

## Summary

Uninitialized implementation (initializers disabled, owner zero). The constant signer reaches only proxies that run this code, and no such proxy was found; the address holds no signer state of its own.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Wagies: signed by SIGNER, a constant in the code. Read (function text).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 2 with an upgrade function whose caller was not read.
- slot 0 = 0xff (OZ4 _initialized = 255, initializers disabled) at 26438999 (chain1)
- owner() = 0 (chain1)
- no Upgraded(impl) log in the 400k blocks after deployment (block 15484098)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
