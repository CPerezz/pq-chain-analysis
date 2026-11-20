---
id: multisigwalletv2-2ec6ab52-signer-upgrade-only
title: "MultiSigWalletV2: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x2ec6ab527a62ca41432bbc4ce62b26b8d41b1f03"
  family: "b6dd90f1244813515fa45f1c59701b15"
  copies: 2
  name: "MultiSigWalletV2"
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
  note: "Refuted: an uninitialized master copy; clones are their own rows."
---

## Summary

MultiSigWalletV2 master copy: owners are set by setup() in each clone; getOwners() on this address is empty, so it holds no signer set and no funds.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MultiSigWalletV2 checkSignature: validator and operator thresholds of stored owners / MultiSigWalletV2 checkSingleSignature: a stored owner must sign. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- getOwners() = [] at 26438999 (facts getters)
- owners are written only in setup() (BaseMultiSigWallet.sol:40)
- value 0; txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
