---
id: d920690d-signer-upgrade-only
title: "0xd920690d (tagged deployed by Alchemy: Bundler 1): signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd920690dbce161953383d5e34e298481ed069607"
  family: "799514587da29ae36df64a23b4d4068e"
  label: "deployed by Alchemy: Bundler 1"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "any owner of the account"
evidence:
  level: bytecode
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
  note: "Signer set is settable by its owners: refuted."
---

## Summary

Multi-owner ERC-4337 (EntryPoint v0.6) account implementation deployed by Alchemy's bundler. The 'copy of template 0d335599 (Sedition)' match is wrong. Owners are a settable set.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: stored-key (by upgrade): the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Placed by a rule; copy of template 0d335599, not read on its own.
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Decompile: 0xacfd82f2(address) sets owners[arg0]=1 (OwnershipGranted) and 0x83cfbd7f(address) clears it (OwnershipRevoked); callable by an owner or by the account itself
- upgradeTo/upgradeToAndCall require owners[msg.sender]; withdrawDepositTo also owner-gated (direct call, no signature)
- review/queue.csv: proxy 0x8bcaefbe… (3 copies) runs this implementation

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before migrating a key, an owner grants a new owner and revokes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
