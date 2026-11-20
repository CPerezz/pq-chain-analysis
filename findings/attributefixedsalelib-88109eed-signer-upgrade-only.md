---
id: attributefixedsalelib-88109eed-signer-upgrade-only
title: "AttributeFixedSaleLib: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x88109eed892a6fa8270b1c6d77604b2bdf53e541"
  family: "8ccef3f09da775b84b62dddf217f10bf"
  name: "AttributeFixedSaleLib"
  upgradeable: "yes"
  admin: "0xfe93d561a66c7f71862219bbd640bddb9f7eb1be"
  rating: LOW
  txs_90d: 1263
  last_active: 2026-11-13
fix:
  layer: contract-upgrade
  who_acts: "7702-delegated EOA owner 0xfe93d561…"
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
  note: "The owner being 7702-delegated does not block it from calling as itself (7702 only adds code that runs when something calls INTO that address; the EOA still signs its own outgoing transactions). Live owner: LOW."
---

## Summary

AttributeFixedSaleLib: the recovered address must equal the stored signer, or be in a stored set/role; the owner can upgrade or set a new signer.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x239054f7efce1e29e0cac3ab1609f0c8e71f368c with UPGRADE_INTERFACE_VERSION(), owner 0xfe93d561a66c7f71862219bbd640bddb9f7eb1be.
- owner() at 26438999 = 0xfe93d561a66c7f71862219bbd640bddb9f7eb1be
- that owner's own code at 26438999 is an EIP-7702 delegation indicator (23 bytes, 0xef0100…), not arbitrary code; it is still the EOA's own key sending transactions, nonce 828 (active)
- setters include setSignerAddress(address) and transferOwnership(address)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,263 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Owner calls setSignerAddress or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
