---
id: gppurchaserv3-b66dc9d6-signer-upgrade-only
title: "GpPurchaserV3: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb66dc9d6005bec365bf87609c342fb9f3889659b"
  family: "de424beb61ebc2b82150294d408fa358"
  name: "GpPurchaserV3"
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
  note: "The signer set has a setter that works by direct calls of the same owners, so it is not upgrade-only. I did not read the owner set or admin liveness (node)."
---

## Summary

GpPurchaserV3 implementation (live behind 0xb03aaf70, 4.75 ETH). Admin signatures must come from a stored owner set that the owners themselves rotate by direct calls (requestUpdateOwner/confirmUpdateOwner).

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: GpPurchaser admin signature: the signer must be an owner / GpPurchaser _recoverSigner: returns the signer. Read from source.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- GpPurchaserV3.sol:385-396 _verifyAdminSignature: isOwner[ecrecover(...)]
- GpPurchaserV3.sol:226-290 requestUpdateOwner/confirmUpdateOwner (onlyOwner, threshold of confirmations) swap isOwner entries - no signature needed
- proxy 0xb03aaf70191c22d1410d72c3ca9a86ae9eb9942c impl = 0xb66dc9d6, balance 4.747 ETH (state.json @26438999); _authorizeUpgrade onlyAdmin

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners rotate each key to a fresh one with request/confirmUpdateOwner before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
