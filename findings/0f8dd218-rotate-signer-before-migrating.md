---
id: 0f8dd218-rotate-signer-before-migrating
title: "0x0f8dd218: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0f8dd218ee17eee03d254805f84c7ba613e45e62"
  family: "10059bd17031e81adebc528438e7818b"
  copies: 216
  upgradeable: "yes"
  rating: LOW
  value_usd: 1104030
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 952
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "registry owner (EOA 0x828F86BC)"
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
  note: "LOW: live EOA controls the registry and the upgrade."
---

## Summary

Unverified vault account (216 proxies). isValidSignature checks ECDSA signers permitted by an external registry (slot 6); funds move by direct calls.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: vault accounts (214 proxies, about 612 ETH with tokens): isValidSignature recovers the signer (with the low-s check) and asks the account's external security scheme whether that signer may act for…. Bytecode and names.
- slot 6 = registry 0x0618275c, whose owner() = 0x828F86BC (EOA, nonce 211)
- 1967 admin 0xc4e7dbec has owner() = the same EOA; account owner() = 0x7c615e12 (EOA, nonce 2061)

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 216 addresses).
- Activity: 952 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The registry owner changes roles, or the admin upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
