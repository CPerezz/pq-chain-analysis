---
id: zksync-abea9132-entry-by-own-signature-only
title: "ZkSync: entry only by one's own signature"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0xabea9132b05a70803a4e85094fd0e1800777fbef"
  family: "6d8cc566d5674cc89447a00e343b86d7"
  copies: 3
  name: "ZkSync"
  label: "zkSync"
  upgradeable: "yes"
  rating: LOW
  value_usd: 23279
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 58
  last_active: 2026-11-16
fix:
  layer: offchain
  who_acts: "security council members"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The same act stays open by a direct call (signed shortcut), so LOW. value_usd 23279, txs_90d 58."
---

## Summary

zkSync Lite: security council members (a fixed list) can cut the upgrade notice period by signature; each member can also approve by a direct call.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite…. Read from source.
- AdditionalZkSync.sol:101-105 cutUpgradeNoticePeriod(bytes32) approves for msg.sender (direct)
- AdditionalZkSync.sol:111-125 cutUpgradeNoticePeriodBySignature recovers each member

## Impact and exposure

- Value held at block 26,438,999: $23,279 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 58 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Council members with code approve by direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
