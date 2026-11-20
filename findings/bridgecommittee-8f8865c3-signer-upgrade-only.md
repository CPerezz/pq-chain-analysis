---
id: bridgecommittee-8f8865c3-signer-upgrade-only
title: "BridgeCommittee: signer replaceable only by an upgrade"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8f8865c3e7b240fa2ec7f3afee28b689319905e8"
  family: "aa89732c3434a2c3e02df31c039228cd"
  copies: 7
  name: "BridgeCommittee"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: none
  who_acts: "the bridge committee itself, by the same ecrecover check that EIP-8151 breaks"
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
  rating: HIGH
  note: "The only 'upgrade function' (row's note) is itself gated by the same committee ecrecover check it would need to route around once enough members' keys take code — no independent admin, confirms HIGH."
---

## Summary

Sui/Mysten BridgeCommittee: message verification and the contract's own upgradeWithSignatures are both gated by committee signatures (ecrecover) via CommitteeUpgradeable._authorizeUpgrade, which only allows an upgrade that was itself authorized through upgradeWithSignatures. Members can only be blocklisted, never replaced, and there is no independent admin.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: committee members by stake, each once, not blocklisted; members are not replaced by a function, only blocklisted. Read from source.
- Update path, read at block 26,438,999: UPGRADE_INTERFACE_VERSION(), but owner() is zero or absent. 7 with an upgrade function whose caller was not read.
- source (CommitteeUpgradeable.sol): _authorizeUpgrade requires _upgradeAuthorized, which is set only inside upgradeWithSignatures(...) after verifyMessageAndSignatures (ecrecover) passes — the upgrade path is not independent of the broken mechanism
- node, block 26438999: owner() reverts on both the implementation and its proxy 0xc3ea459135ae06c3f0df2e0aab9937be28d0037f — no plain Ownable admin exists

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None short of a full migration to a new committee contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
