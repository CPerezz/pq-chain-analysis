---
id: ec4ea87b-signer-upgrade-only
title: "0xec4ea87b: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xec4ea87b2ae4de5c8ba5bf248ff5a9def58da5b5"
  family: "bda0397c4d8cf15d08d9247e3b0aa093"
  copies: 3
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "Implementation copy that no proxy runs, holding nothing: refuted. Slots 1-2 of this address were not read before the node stopped answering."
---

## Summary

A bare copy of the multisig implementation 0x757bd642… (same code hash 0xfca900c4). The only proxy of this family, 0xbc29c0d3…, runs 0x757bd642, not this address.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Family bda0397c facts: one code (0xfca900c4…, 23,599 bytes), 3 addresses: 2 direct (0x757bd642, this) + 1 proxy
- proxyprobe/dossier: proxy 0xbc29c0d3… impl slot = 0x757bd642… (≠ row), admin slot 0
- 0xec4ea87b at 26438999: no 1967 slots, slot 0 = 0, balance 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
