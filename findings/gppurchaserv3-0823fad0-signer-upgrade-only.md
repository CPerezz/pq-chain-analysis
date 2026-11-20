---
id: gppurchaserv3-0823fad0-signer-upgrade-only
title: "GpPurchaserV3: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x0823fad0616093b9779657da8f053faab316dc4a"
  family: "440f0d16c83ceb7b8cfdd2ce42f6bb03"
  name: "GpPurchaserV3"
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
  note: "Refuted: the key is settable (owners rotate by a direct-call vote)."
---

## Summary

GpPurchaserV3: the signers are the stored owners, and the owners can replace any owner with requestUpdateOwner + confirmUpdateOwner (direct calls, a confirmation threshold). Upgrades are admin-gated. This address is the implementation; proxy 0xe0469f0beeff05effd5c46d35043079db9f1bfe3 runs it.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: GpPurchaser admin signature: the signer must be an owner / GpPurchaser _recoverSigner: returns the signer. Read (function text).
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- requestUpdateOwner/confirmUpdateOwner swap isOwner[old] for isOwner[new] once updateOwnerConfirmThreshold is reached (src/GpPurchaserV3.sol:226-280)
- _authorizeUpgrade is onlyAdmin (GpPurchaserV3.sol:373)
- Upgraded(0x0823fad0…) emitted by 0xe0469f0b…, whose implementation slot still points here at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before migrating, an owner rotates out through requestUpdateOwner/confirmUpdateOwner

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
