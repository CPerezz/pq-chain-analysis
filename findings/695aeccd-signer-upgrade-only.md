---
id: 695aeccd-signer-upgrade-only
title: "0x695aeccd: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x695aeccd0819538fafddc39d4969018a45da800f"
  family: "65d0cf9d45155bdc26acc87fc4f64114"
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
  note: "An implementation locked at deployment (constructor() initializer {}, initializer slot = 1): no signer, state or ETH of its own, so nothing here is affected."
---

## Summary

contracts/Token.sol:Token: initialized state found (or a non-standard proxy) but owner() is zero/absent; who can upgrade and what the stored key signs for could not be settled.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeToAndCall). Placed by a rule; copy of template 35075ad3, not read on its own.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- block 26438999 (read before the node saturated): owner()=NA, EIP-1967 admin slot=0, slot0=0x0000000000000000000000000000000000000000000000000000000000000000, OZv5 initializer slot low bytes=0000000000000001, ETH balance=0.000000000000000000
- Upgrade selectors: UPGRADE_INTERFACE_VERSION(),upgradeToAndCall(address,bytes),upgradeToAndCall_23573451(); txs_90d=0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
