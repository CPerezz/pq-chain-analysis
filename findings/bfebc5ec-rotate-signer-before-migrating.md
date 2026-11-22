---
id: bfebc5ec-rotate-signer-before-migrating
title: "0xbfebc5ec: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbfebc5ecac789643a61fadf15048a37dc9612dcf"
  family: "54b7a1c285bc42881fe64cf299bfa7bb"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 2707
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3778
  last_active: 2026-11-18
  recoveries_14d: 954
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN/UPGRADER Safe 0x09e84186…d0f4"
evidence:
  level: executed
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
  note: "Role admin plus upgrader, live Safe (1-of-1)."
---

## Summary

Unverified UUPS proxy (impl 0xf036cfa5…) with redeemWithAttestation: attestations are signed by role holders. A role holder with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole, setGmTokenManager, setPriceOracle). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- RoleGranted logs: DEFAULT_ADMIN and UPGRADER_ROLE granted to 0x09e841868da1c94ac5fbc317dff2e00f82a8d0f4
- hasRole(DEFAULT_ADMIN, 0x09e8…) = true and hasRole(UPGRADER_ROLE, 0x09e8…) = true at block; it is a Safe, 1 of 1 owner (0x7946669e…)
- Deployer 0x216f9b7f… no longer holds admin/upgrader

## Impact and exposure

- Value held at block 26,438,999: $2,707 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,778 transactions called it in the 90 days before that block; last on 2026-11-18.
- 954 signature recoveries in the study's two-week trace window.

## Remediation

The admin Safe grants/revokes the signer role, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
