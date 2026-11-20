---
id: 134ede25-signer-upgrade-only
title: "0x134ede25: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x134ede251322ac66ceaf97dddc0031b2f59f5b88"
  family: "55094f8d1564c69bb4037111d7751418"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: the address is an implementation whose initializers are disabled and whose signer is unset. Main reviewer: its 77 proxies may need rows of their own; their owner() could not be read (node timeout)."
---

## Summary

Uninitialized implementation contract (UUPS, one stored key): its own storage has no signer, owner or funds; proxies that run it keep their own state and upgrade path and are rated as their own rows.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 2 with an upgrade function whose caller was not read.
- slot 0 = 0xff (OZ4 _initialized = 255, initializers disabled) at 26438999 (chain1)
- owner() returns zero or reverts at 26438999; EIP-1967 implementation and admin slots are empty (chain1)
- 77 proxies emitted Upgraded(0x134ede…), and those checked still point here (e.g. 0x00860d0a…, 0x02fde0d1…), each with its own storage

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
