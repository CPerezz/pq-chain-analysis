---
id: da864364-rotate-signer-before-migrating
title: "0xda864364: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xda864364f7d1ebcc7c89e9610ebdef45ddf5f81b"
  family: "5ed13761466b5b85a4a02c2b3efefa98"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1507
  last_active: 2026-11-18
  recoveries_14d: 147
fix:
  layer: onchain-config
  who_acts: "owner 0xa3Cb…64b5"
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
  note: "Anon's rule (2026-11-20): a key that has never sent a transaction is presumed live; inactivity does not show the key is lost. So the party that can rotate the signer or upgrade the code can act: LOW. Earlier doubt: Setter and upgrade both exist, but the only caller is an EOA that has never transacted, so I can't confirm it is live. LOW holds if that key is held."
---

## Summary

UUPS proxy (impl 0x1ae003e6…db1d, Solady OwnableRoles); signers are role holders set via grantRoles.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRoles, revokeRoles). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- grantRoles(address,uint256) and upgradeToAndCall are owner-only (msg.sender == owner slot) in impl decompile
- owner() = 0xa3Cb56292E5c4C2180A4A0635f5FbD49c0Cc64b5 at block 26438999: no code, nonce 0 (never sent a transaction)

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,507 transactions called it in the 90 days before that block; last on 2026-11-18.
- 147 signature recoveries in the study's two-week trace window.

## Remediation

owner grants the role to a fresh EOA and revokes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
