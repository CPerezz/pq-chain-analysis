---
id: faefea4f-rotate-signer-before-migrating
title: "0xfaefea4f: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfaefea4f45c8a7af8c8c591ae6b69a19946d0b08"
  family: "82ce892c980fa78108e914e602b7721b"
  upgradeable: "no"
  rating: LOW
  value_usd: 11188
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 47
  last_active: 2026-11-16
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0xcbc2c69fb862fa1dd6d349d44ae2a78101642e0e"
evidence:
  level: bytecode
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
  note: "The setter is gated by a role whose admin is a live EOA that can grant it: LOW. I did not map exactly which role hash gates the setter; the admin holds DEFAULT_ADMIN and every role granted at deploy."
---

## Summary

TreasureChest (unverified) claim() needs a signature recovered to a stored rewardClaimSigner. Claims die if that signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setRewardClaimSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: setRewardClaimSigner(address) requires a role (storage_map_a[msg.sender], AccessControlUnauthorizedAccount error 0xe2517d3f)
- RoleGranted at deploy (block 23518804): 0xcbc2…0e0e got DEFAULT_ADMIN and roles 9f4feb59/4213624a/b9ae9300
- hasRole(0x00,0xcbc2…0e0e)=true at block 26438999; EOA, nonce 273

## Impact and exposure

- Value held at block 26,438,999: $11,188 (ETH and 49 priced tokens).
- Activity: 47 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

The admin (or a holder of the setter role) calls setRewardClaimSigner with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
