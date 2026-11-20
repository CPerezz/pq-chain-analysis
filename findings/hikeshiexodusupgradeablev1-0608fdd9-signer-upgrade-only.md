---
id: hikeshiexodusupgradeablev1-0608fdd9-signer-upgrade-only
title: "HikeshiExodusUpgradeableV1: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0608fdd96736a648c9c77f3b98791b4c4281d0b7"
  family: "d05c6fed56426aab0dd5edbd0526dd8f"
  name: "HikeshiExodusUpgradeableV1"
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

- How it was placed: Hikeshi mint: signed by _CLAIM_ADMIN_SIGNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- OZ5 Initializable slot 0xf0c57e16…6a00 = 0xff..ff (initializers disabled) at 26438999 (chain1)
- owner() = 0 (chain1)
- _CLAIM_ADMIN_SIGNER is a code constant (row note)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none needed for this address

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
