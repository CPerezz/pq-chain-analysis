---
id: liquiditypoolaave-63ff95c7-rotate-signer-before-migrating
title: "LiquidityPoolAave: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x63ff95c79bf61486c600eb8af4cce4c0a9a4068b"
  family: "df3a25177675339c07dc08fe0c0d2571"
  copies: 4
  name: "LiquidityPoolAave"
  upgradeable: "yes"
  rating: LOW
  value_usd: 12
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1277
  last_active: 2026-09-24
fix:
  layer: onchain-config
  who_acts: "Safe 0x4eA9…0636"
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
  note: "setter role reachable by a live Safe default admin, which also owns the ProxyAdmin. The exact role on 0x046dc166 was not decoded."
---

## Summary

LiquidityPoolAave proxy (impl 0x741369a8…6a71) checking a stored signerAddress.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template 4a2c7a03: the recovered address must be the stored signer, or be in a stored set or role of signers. Template.
- setSignerAddress(address) 0x046dc166 is AccessControl-gated (error 0xe2517d3f) in impl decompile
- hasRole(DEFAULT_ADMIN_ROLE, 0x4eA9E682…0636) = true at block 26438999: Safe, threshold 3 of 4; getRoleAdmin(LIQUIDITY_ADMIN_ROLE) = DEFAULT_ADMIN_ROLE
- EIP-1967 admin = ProxyAdmin 0x45b5f91a…96c7, owner() = the same Safe 0x4eA9…0636

## Impact and exposure

- Value held at block 26,438,999: $12 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,277 transactions called it in the 90 days before that block; last on 2026-09-24.

## Remediation

Safe (directly or by granting the role) sets a fresh EOA signerAddress

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
