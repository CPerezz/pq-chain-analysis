---
id: 77bf3026-signer-upgrade-only
title: "0x77bf3026: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x77bf302667deccbc65dd59b08a334cadcdbdc2bf"
  family: "24e73ad618ef90fe7d90c77b3116ea7e"
  copies: 2
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

- How it was placed: quote signer that is a constant in the code, behind a proxy. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- OZ5 Initializable slot 0xf0c57e16…6a00 = 0xff..ff (initializers disabled) at 26438999 (chain1)
- owner() = 0 (chain1)
- Ownable selectors (owner/transferOwnership/renounce) in the decompile of the code read at the latest block, ~26452927

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
