---
id: 1f2788f8-rotate-signer-before-migrating
title: "0x1f2788f8: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1f2788f8fdf2ba0014cfd49264846a6a1e8b5888"
  family: "f6f0bf23d38426dbf2998e1b11d03536"
  upgradeable: "no"
  rating: LOW
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "the wallet's owners (3 of 4 owner signatures)"
evidence:
  level: bytecode
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
  note: "LOW: owners rotate each other with a 3-of-4 quorum, so one owner that takes code is replaceable. Owner addresses sit in a mapping and were not enumerated, so their liveness is unchecked."
---

## Summary

Unverified custom multisig (8 ETH, no activity): execute and the owner-management functions each need sorted owner signatures checked by ecrecover against isOwner. An owner account that takes non-7702 code can no longer sign.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: a loop of recoveries for execute; owners by isOwner. Bytecode and names.
- heimdall decompile: isOwner mapping at slot 0, ownerTotal = byte 2 of slot 2; functions 0x850faf84 (adds an owner, ownerTotal+1) and 0x7da26f52 (removes an owner, ownerTotal-1) are signature-gated by the other owners
- slot 2 at block 26438999 = 0x040302: 4 owners, thresholds 3 and 2
- no ERC-1271 or code check (card erc1271=false)

## Impact and exposure

- Value held at block 26,438,999: $14,436 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before an owner's account takes code, the other owners sign an owner replacement (0x7da26f52 to remove, 0x850faf84 to add a fresh key).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
