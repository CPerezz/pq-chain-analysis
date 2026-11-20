---
id: omredpackets-a5cff7b2-signer-upgrade-only
title: "OMRedPackets: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa5cff7b24e5fde6f8a6c9bfaff103781e33ddd35"
  family: "c6a1dbf7b0e02ba6fd3f4de47684360d"
  name: "OMRedPackets"
  upgradeable: "no"
  rating: NONE
  value_usd: 35
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "uninitialized implementation. Its 0.0193 ETH balance is not tied to any packet (the packet counter is empty); that ETH is stranded in any case"
---

## Summary

OMRedPackets implementation: its constructor calls _disableInitializers (slot 0 = 0xff) and its packet storage is empty, so no packet exists to claim here. On the proxies, the constant claim signer is replaced through a UPGRADER_ROLE upgrade.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: OMRedPackets _verifyClaimSignature: a constant address (0xA672…86ac) signs each claim. Read (function text).
- Update path, read at block 26,438,999: UPGRADER_ROLE(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- constructor _disableInitializers(); claim signer constant 0xA6724E3a… (an EOA, latest block ~26452920) (dossier source)
- Slot 0 = 0xff; slots 1-10 and 251 are empty (node, block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $35 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
