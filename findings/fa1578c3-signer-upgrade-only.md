---
id: fa1578c3-signer-upgrade-only
title: "0xfa1578c3: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfa1578c380311a1c4171ee5386ab87d67cc14ac7"
  family: "2e7c4a6a49fdb933549860dd1eb11b61"
  copies: 2
  upgradeable: "yes"
  admin: "0x9b288bb8e08a3b943023557387fbed83c2f8cc4b (upgradeDelegate, slot1)"
  rating: LOW
  value_usd: 3
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "operator 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b"
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
  verdict: confirmed
  rating: LOW
  note: "Live upgrade path via the proxy's own admin slot1 (live EOA)."
---

## Summary

265-byte proxy (slot0 = implementation 0x3d615fab..., slot1 = 0x9b288bb8...); the implementation's isValidSignature compares ecrecover with constant 0x9b288bb8..., and upgradeDelegate(address) by slot1 repoints it.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy; a signer that is a constant in the code. Same code idiom as template 9f802c7a, not read on its own.
- Update path, read at block 26,438,999: proxy to 0x3d615fabc3fd28a8a92efc160b41eb0a7e17a836: no admin, no upgrade function in the implementation.
- cast storage at 26438999: slot0 = 0x3d615fabc3fd28a8a92efc160b41eb0a7e17a836, slot1 = 0x9b288bb8e08a3b943023557387fbed83c2f8cc4b
- decompile of 0xfa15...: upgradeDelegate(address) requires msg.sender == slot1, writes slot0
- decompile of 0x3d615fab...: 1626ba7e magic only when ecrecover == 0x9b288bb8... (constant)
- 0x9b288bb8... nonce 231, code 0x (live EOA)

## Impact and exposure

- Value held at block 26,438,999: $3 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator calls upgradeDelegate with a new implementation before its key takes real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
