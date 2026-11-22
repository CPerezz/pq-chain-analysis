---
id: superbunnies-3a3fba79-signed-shortcut-lost
title: "SuperBunnies: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x3a3fba79302144f06f49ffde69ce4b7f6ad4dd3d"
  family: "23379bc4ea2a17d7bfd833b3d091b047"
  name: "SuperBunnies"
  label: "Super Bunnies: SB Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 513036
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-10-19
fix:
  layer: account-migration
  who_acts: "the holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Same act open by direct call → LOW."
---

## Summary

SuperBunnies ERC-721 with NativeMetaTransaction: executeMetaTransaction recovers the user; a user with code fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: meta-transaction relay (NativeMetaTransaction): the user named in the call must have signed; the relayed functions are open to the user's own call. Read from source.
- ERC721.sol:135/152/166 setApprovalForAll, transferFrom, safeTransferFrom are direct
- NativeMetaTransaction.sol:32 only relays calls the user can make itself

## Impact and exposure

- Value held at block 26,438,999: $513,036 (ETH and 49 priced tokens).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-10-19.

## Remediation

User calls the function directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
