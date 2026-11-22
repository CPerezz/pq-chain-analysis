---
id: ac12a532-rotate-signer-before-migrating
title: "0xac12a532: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xac12a5324cd7514b72cb10b95b3877bd570a75c0"
  family: "a223192ad4ba42225ed72de3623c6829"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 180
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1216
  last_active: 2026-11-18
  recoveries_14d: 1422
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder 0xa07a…70bb"
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
  note: "role setter callable by a live EOA default admin"
---

## Summary

Transparent proxy (impl 0x96209d32…eb6c) filling orders signed by role holders (OZ AccessControl).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: orders with a named signer and role holders (grantRole). Bytecode and names. Executed: a real transaction reverts with code at the signer.
- grantRole(bytes32,address) role-admin gated in impl decompile; getRoleAdmin of the granted roles 0x65d7a2…/0x427da2… = DEFAULT_ADMIN_ROLE
- hasRole(DEFAULT_ADMIN_ROLE, 0xa07ae4bdfa7ba8bc0e8a8525bcc768300a8970bb) = true at block 26438999; EOA, nonce 60
- EIP-1967 admin = ProxyAdmin 0x0847a91f…0414, owner 0x082D3dCD…6d37 (contract, 5407 bytes)

## Impact and exposure

- Value held at block 26,438,999: $180 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,216 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,422 signature recoveries in the study's two-week trace window.

## Remediation

default admin grants the signer role to a fresh EOA and revokes the old one

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
