---
id: coderebels-11ad1fe2-signer-upgrade-only
title: "CodeRebels: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x11ad1fe2f584ea96d3505554968fe710b89a5ae8"
  family: "4ad791cd2506fea2438e0ebc37277434"
  name: "CodeRebels"
  upgradeable: "yes"
  admin: "0x95fbf89b98a64dbacd2ea2c896260815058040fc"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the admin upgrades the code (proxy to 0x726f7e8542459a7d0036c7c3d970b3eb79bf376c with upgradeTo(address), owner 0x95fbf89b98a64dbacd2ea2c896260815058040fc)"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`CodeRebels` at `0x11ad1fe2f584ea96d3505554968fe710b89a5ae8`. It accepts signatures from a key that only an upgrade can replace; once that key's account has code, the signed functions stop until the code changes.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: returns the recovered address, or compares it with an address its caller passes in / CodeRebels verifyX: a constant address (0x55fd…872A) must sign the caller. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x726f7e8542459a7d0036c7c3d970b3eb79bf376c with upgradeTo(address), owner 0x95fbf89b98a64dbacd2ea2c896260815058040fc.
- Reviewed through the root issue's mechanism (D-025): the signer is replaceable only by upgrading the code, and a live upgrade path was measured at this address (the admin or owner behind its proxy slot or upgrade function): LOW
- Mechanical check: this address does not run a UUPS implementation directly (those cannot upgrade at their own address and were sent to one-by-one checks)
- A random sample of 25 of the 210 rows below Anon's thresholds: 16 held at LOW, 5 were such implementations, 4 could not be settled while the node was down

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin upgrades the verification, or the key holder keeps the key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
