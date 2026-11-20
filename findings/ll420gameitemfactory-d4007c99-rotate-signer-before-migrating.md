---
id: ll420gameitemfactory-d4007c99-rotate-signer-before-migrating
title: "LL420GameItemFactory: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd4007c99068d8a7f95ca2bce8e46bc0138ccc9c1"
  family: "707d8434b70d2745d0ee8ae380483484"
  name: "LL420GameItemFactory"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "An unused implementation: owner and signer are zero at this address, so no signature it checks can matter here; any effect sits in the proxies that run this code, which are rows of their own."
---

## Summary

LL420GameItemFactory: buy() needs a signature from _validator, which is set only in initialize(); there is no setter, and the owner is not the signer (row note is wrong).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- _verify: recover == _validator; _validator written only in initialize() (verified source lines 110, 297)
- owner() at 26438999 = 0x0 (node); storage slots 0-7 all zero (publicnode latest ~26452944; no setter, uninitialized)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
