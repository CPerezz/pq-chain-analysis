---
id: marchanddeglacemock-e5585c26-signer-upgrade-only
title: "MarchandDeGlaceMock: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe5585c269b67dc918487fc6da9bb7598d4249edc"
  family: "d04e61e65aa9015955a9ab2dda48822a"
  name: "MarchandDeGlaceMock"
  upgradeable: "yes"
  admin: "EOA 0xf953c3d4… (EIP-1967 admin / owner, nonce 273)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "proxy admin EOA 0xf953c3d4…"
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
  verdict: confirmed
  rating: LOW
  note: "Live admin: LOW."
---

## Summary

MarchandDeGlace token-sale implementation (whale/dolphin passes signed by immutable SIGNER) behind EIP-173 proxy 0x1e6724a4…. The proxy admin is a live EOA, which can also withdrawETH/withdrawUnlockedGEL.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: MarchandDeGlace: whale and dolphin passes signed by SIGNER, an immutable; the proxy can replace the code. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: address public immutable SIGNER; buyWhale/buyDolphin require SIGNER's signature
- Proxy 0x1e6724a4… impl = 0xe5585c26, admin slot = 0xf953c3d475dc0a9877329f71e2ce3d2519a519a2 (EOA, nonce 273); proxy balance 0.4039 ETH at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin upgrades to an implementation built with a new SIGNER.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
