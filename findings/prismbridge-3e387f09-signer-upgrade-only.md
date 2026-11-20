---
id: prismbridge-3e387f09-signer-upgrade-only
title: "PrismBridge: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x3e387f099a15ae749dc18ad2e1238a73c9289019"
  family: "12ffa7329a231da1771e8e079795d461"
  name: "PrismBridge"
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
  note: "Refuted: the address is an implementation whose initializers are disabled and whose signer is unset."
---

## Summary

Uninitialized implementation contract (PrismBridge): its own storage has no signer, owner or funds; proxies that run it keep their own state and upgrade path and are rated as their own rows.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: PrismBridge _isSignedByValidator: the stored validator must have signed. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- admin() = 0 at 26438999 (facts getters)
- state is set only by initialize() (PrismBridge.sol:31)
- slot 0 = 0 (chain1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
