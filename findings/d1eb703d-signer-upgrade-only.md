---
id: d1eb703d-signer-upgrade-only
title: "0xd1eb703d (tagged created by Nuo Network: Account Factory v2): signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xd1eb703dc966d67236fd94a66ab87fb9aeff092c"
  family: "5b1bfd640dabed0beacce4c09914fcee"
  label: "created by Nuo Network: Account Factory v2"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "a current user of each account (signs addUser/removeUser), relayed by the config's valid admin"
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
  note: "Key is settable (user-signed add/remove), plus a signature-free operator path: refuted for upgrade-only."
---

## Summary

Master copy of an exchange deposit-account system (2,703 proxies via slot 0). The user set is replaceable: addUser/removeUser (and changeImpl) are signed by an existing user, and transferBySystem moves funds with no user signature.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: changeMasterCopy(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- Decompile: addUser(address,uint256,bytes) sets users[arg0]=1 and removeUser(address,uint256,bytes) clears it, both after isAdminValid(msg.sender) on the config and a user-signature check
- Decompile: changeImpl(address,uint256,bytes) is user-signed and calls changeMasterCopy (self-only), which rewrites slot 0
- transferBySystem(address,address,uint256) moves tokens after a config handler check (INVALID_ACC_HANDLER); no signature
- Dossier state: proxy 0xb58fb98b… slot_0 = 0xd1eb703d…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before a user's key gets code, another user (or that key) signs addUser for a new key; the operator can also move funds with transferBySystem.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
