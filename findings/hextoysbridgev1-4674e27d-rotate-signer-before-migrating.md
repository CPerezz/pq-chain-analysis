---
id: hextoysbridgev1-4674e27d-rotate-signer-before-migrating
title: "HexToysBridgeV1: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x4674e27daaf7755a84e71a058a3da1163abae0e8"
  family: "f0a7573e94f913c631f918017012c7c8"
  name: "HexToysBridgeV1"
  upgradeable: "yes"
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

HexToysBridgeV1 UUPS implementation: bridge claims checked against signer; setSigner onlyOwner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- constructor calls _disableInitializers(); setSigner onlyOwner (verified source lines 105, 118)
- owner() at 26438999 = 0x0 (node); signer() = 0x0, slot0 = 0xff (initializers disabled) (publicnode latest ~26452944)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Rotate the key before its account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
