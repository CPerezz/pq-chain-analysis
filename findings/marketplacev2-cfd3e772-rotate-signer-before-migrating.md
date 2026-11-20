---
id: marketplacev2-cfd3e772-rotate-signer-before-migrating
title: "MarketplaceV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcfd3e772338ee65193e74eb0e70ecb228afb5df7"
  family: "2327f2f04503b957b8d50e7a21ee1d30"
  copies: 2
  name: "MarketplaceV2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 9384
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-10-01
fix:
  layer: onchain-config
  who_acts: "owner/admin 0x8A58f8Ab…9952 (EOA)"
evidence:
  level: source-read
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
  note: "Role setter plus upgrade path, both held by a live EOA. [INFERENCE] that EOA holds DEFAULT_ADMIN_ROLE (not checked); the upgrade path is verified."
---

## Summary

MarketplaceV2 NFT creation requires a signature recovered to an AUCTION_FINISHER_ROLE holder. A role holder with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address, or whether it equals an address its caller passes in. Read from source.
- MarketplaceV2.sol:444-449 recoverSigner then hasRole(AUCTION_FINISHER_ROLE, signer); AccessControlUpgradeable grant/revoke
- owner() = 0x8A58f8Ab955313DE64633F7Dc61F2dB1F12b9952, no code, nonce 5
- Also upgradeable: EIP-1967 admin 0xe305ab43… (ProxyAdmin) whose owner() is the same EOA

## Impact and exposure

- Value held at block 26,438,999: $9,384 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-10-01.

## Remediation

The role admin grants AUCTION_FINISHER_ROLE to a key without code, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
