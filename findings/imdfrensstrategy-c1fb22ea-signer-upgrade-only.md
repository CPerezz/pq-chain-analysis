---
id: imdfrensstrategy-c1fb22ea-signer-upgrade-only
title: "IMDFrensStrategy: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc1fb22eae876ab8df30208caeeffd76f014424e8"
  family: "dac79c251e9a864fb8666aca45326ab8"
  name: "IMDFrensStrategy"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1
  last_active: 2026-10-19
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
  note: "uninitialized implementation; on the proxies that use it, COSIGNER is fixed by an owner upgrade (LOW there)"
---

## Summary

IMDFrensStrategy implementation: BaseStrategy's constructor calls _disableInitializers and its owner is empty. COSIGNER is an immutable of the implementation, and the proxies that use it replace it through an owner-gated UUPS upgrade (_authorizeUpgrade onlyOwner).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady ERC20 permit (variant, assembly): the recovered address must be the owner named / IMDReleaseStrategy _cosigned: COSIGNER, an immutable. Read (function text).
- Update path, read at block 26,438,999: upgradeToAndCall(address,bytes), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- BaseStrategy constructor calls _disableInitializers(); _authorizeUpgrade is onlyOwner (dossier source)
- Slot 0, the EIP-1967 slots and the balance are all 0 (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-19.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
