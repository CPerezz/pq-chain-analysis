---
id: bridgecommittee-ee2d5247-signer-upgrade-only
title: "BridgeCommittee: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xee2d52477a7c1a7be0b0347dbe7e3b15185b416f"
  family: "aa89732c3434a2c3e02df31c039228cd"
  copies: 5
  name: "BridgeCommittee"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 2869
  last_active: 2026-11-17
  recoveries_14d: 2771
fix:
  layer: contract-upgrade
  who_acts: "the committee itself, via upgradeWithSignatures gated by the same stake-weighted ECDSA check as every other committee action"
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
  note: "No independent admin exists; the 'upgrade path' is gated by the same at-risk signer mechanism as the row's root ecrecover check, just with a stake threshold rather than one key. Current heavy, successful signing volume shows the committee is live today, but this is weaker than the other rows' independent admin/Safe/timelock evidence — flagging for the main reviewer's judgment on whether a same-mechanism-but-thresholded upgrade still counts as the 'live upgrade path' the LOW bar wants."
---

## Summary

Sui Bridge's BridgeCommittee: committee members (fixed by stake at init, never replaced by a function, only blocklisted) sign bridge messages; upgradeWithSignatures uses the identical verifySignatures/ecrecover path as normal operation.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: committee members by stake, each once, not blocklisted; members are not replaced by a function, only blocklisted. Read from source.
- Update path, read at block 26,438,999: proxy to 0x1757944e10325e8f44e8cff4974dcc3857411b37 with UPGRADE_INTERFACE_VERSION(), called through its own checks.
- source (BridgeCommittee.sol, CommitteeUpgradeable.sol): upgradeWithSignatures and _authorizeUpgrade both route through verifySignatures, the same ecrecover + stake-threshold check used for every other bridge message, including updateBlocklistWithSignatures which can blocklist a compromised member
- recoveries_14d=2771 and txs_90d=2869 up to 2026-11-17: the committee's signatures are currently recovering successfully at volume, so no current member holds code that would break recovery

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 2,869 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2,771 signature recoveries in the study's two-week trace window.

## Remediation

Committee members sign to blocklist a comped member (removing it from the stake count) or to upgrade directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
