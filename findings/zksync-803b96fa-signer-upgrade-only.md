---
id: zksync-803b96fa-signer-upgrade-only
title: "ZkSync: signer replaceable only by an upgrade"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x803b96fa3ce086a722cb6c1e2c79d304c8a263ff"
  family: "6d8cc566d5674cc89447a00e343b86d7"
  copies: 2
  name: "ZkSync"
  label: "zkSync"
  upgradeable: "yes"
  admin: "any of the 15 constant security-council addresses (direct call), or the 1-of-1 Safe behind getMaster() for the underlying governance"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "any of the 15 fixed zkSync Lite security-council members, by a direct call"
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
  note: "Same act (cutting the notice period) stays open via a direct call that bypasses ecrecover entirely — LOW."
---

## Summary

zkSync Lite AdditionalZkSync.cutUpgradeNoticePeriod(bytes32) is delegated from the main contract and checks msg.sender directly against the 15-member council list — no ecrecover is involved. cutUpgradeNoticePeriodBySignature is only a convenience batch-by-signature alternative to the same call. The contract is already in exodus mode.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: zkSync Lite cutUpgradeNoticePeriodBySignature: members of the security council, a list fixed in the code, approve by signature; a member can also approve by its own call / zkSync Lite…. Read from source.
- Update path, read at block 26,438,999: cutUpgradeNoticePeriod(bytes32), but owner() is zero or absent. 2 with an upgrade function whose caller was not read.
- AdditionalZkSync.sol: cutUpgradeNoticePeriod(bytes32) -> approveCutUpgradeNoticePeriod(msg.sender), which only compares msg.sender to the 15 constant council addresses; no ecrecover on that path
- cutUpgradeNoticePeriodBySignature loops recoverAddressFromEthSignature then calls the same approveCutUpgradeNoticePeriod — purely an alternative entry to the same effect
- node, block 26438999: isReadyForUpgrade()=true, exodusMode()=true, getMaster()=0xE24f4870Ab85DE8E356C5fC56138587206c70d99 (1-of-1 Safe, owner EOA nonce=1)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Any live council member calls cutUpgradeNoticePeriod directly; no signature needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
