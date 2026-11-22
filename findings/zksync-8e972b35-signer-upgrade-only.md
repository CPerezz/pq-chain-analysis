---
id: zksync-8e972b35-signer-upgrade-only
title: "ZkSync: signer replaceable only by an upgrade"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8e972b354e6933275513c355ee14d44a832ad2d9"
  family: "cfbfb41726465f7e920fd971f5cdb302"
  name: "ZkSync"
  upgradeable: "no"
  rating: LOW
  value_usd: 2657
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "security council members"
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
  note: "The same act stays open through a direct call"
---

## Summary

zkSync Lite implementation: cutUpgradeNoticePeriodBySignature has a direct-call twin, cutUpgradeNoticePeriod(bytes32), by which each council member approves with their own call.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite…. Read from source.
- Update path, read at block 26,438,999: cutUpgradeNoticePeriod(bytes32), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Both functions delegate to the additional contract; the note and source say members can also approve by their own call (dossier source ZkSync.sol)
- code 23203 bytes, no proxy slot; this is the implementation behind zkSync's proxy (survey)

## Impact and exposure

- Value held at block 26,438,999: $2,657 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Council members approve by direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
