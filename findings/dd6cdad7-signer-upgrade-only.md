---
id: dd6cdad7-signer-upgrade-only
title: "0xdd6cdad7: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xdd6cdad79d610132d6e1a138017651e127719f9d"
  family: "a667cc8c1f06f78f9ce8b3489fda9299"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  note: "Uninitialized implementation (owner and signer zero): refuted."
---

## Summary

UUPS implementation of an NFT mint contract, not a live instance: upgrade functions are onlyProxy and owner() and signer() read zero at this address, so no signature can ever match here.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is one key kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template ad8cefc3, not read on its own.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- decompile: upgradeTo requires address(this) != 0xdd6cdad79d610132d6e1a138017651e127719f9d ('Function must be called through delegatecall') and an active proxy
- proxiableUUID() returns 0x360894a1... (only answers when called directly on an implementation)
- cast call at 26438999: owner() = 0x0, signer() = 0x0; EIP-1967 slots zero

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address; proxies that run this code are judged at their own addresses.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
