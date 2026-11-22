---
id: upstreamcollectivetoken-c5a6349a-rotate-signer-before-migrating
title: "UpstreamCollectiveToken: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc5a6349aedf573ee01c7bdf3d713496b5a45d056"
  family: "fa2a7e01221b6af2ea7ca0e0db289efb"
  copies: 11
  name: "UpstreamCollectiveToken"
  upgradeable: "yes"
  admin: "Safe 0x8a7e…e13e (3/5)"
  rating: LOW
  value_usd: 25264
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-11-13
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x68a9…54e9"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live Safe owner controls the signer set."
---

## Summary

Upstream Collective token (proxy): its own ERC-1271 accepts signatures of members; also OZ permit.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- addMember/removeMember are onlyOwner (UpstreamCollectiveToken.sol:156,167)
- owner() = Safe 0x68a9…54e9, threshold 3 of 6, EOAs nonces 584/61/34/113 plus two 7702-delegated owners
- EIP-1967 admin = Safe 0x8a7e…e13e, threshold 3 of 5 (live upgrade)

## Impact and exposure

- Value held at block 26,438,999: $25,264 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Owner Safe adds a fresh member key and removes the migrated one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
