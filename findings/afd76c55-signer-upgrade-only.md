---
id: afd76c55-signer-upgrade-only
title: "0xafd76c55 (tagged created by Nuo Network: Account Factory v2): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xafd76c55ff82fb73f60855730ca37eddd6446ec7"
  family: "5b1bfd640dabed0beacce4c09914fcee"
  copies: 2702
  label: "created by Nuo Network: Account Factory v2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 87403
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "any of 3 admin EOAs via config contract 0x431f4290…"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live, active admin keys: LOW."
---

## Summary

A Nuo Network account-factory wallet. changeMasterCopy replaces the implementation and is gated by onlySelf + an admin check against a separate config contract, not by the account's own signer keys.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (changeMasterCopy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xd1eb703dc966d67236fd94a66ab87fb9aeff092c with changeMasterCopy(address), called through its own checks.
- decompiled changeImpl (selector 0x792280c3) requires config.isAdminValid(msg.sender) before self-calling changeMasterCopy
- config 0x431f4290… at 26438999: disableAdminControl()=false (admin list enforced, not open to anyone), getAllAdmins/admins() lists 0x3e990e78…, 0x4f29bf61…, 0x681d2475…, isAdmin true for all three
- all three admins are EOAs with real activity: nonces 678, 64046, 64597 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $87,403 (ETH and 49 priced tokens, over 2,702 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

An admin calls changeImpl to point at a new master copy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
