---
id: 2358693f-rotate-signer-before-migrating
title: "0x2358693f: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2358693f4faec9d658bb97fc9cd8885f62105dc1"
  family: "d7da40139a76d8418461c8114d120195"
  copies: 2
  upgradeable: "yes"
  admin: "DEFAULT_ADMIN_ROLE holder EOA 0x8fda7f45b1427F2d4444F4c6D44D2B5d1cb46b53"
  rating: LOW
  txs_90d: 1155
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder EOA"
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
  note: "Role-gated setter callable by the live EOA admin."
---

## Summary

UUPS proxy (impl 0x3e265130…eaf6) of an AccessControl ERC721 whose signed path checks a stored signer; a signer with code would be rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setMergeConfig, setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- eth_call at block 26438999: setSigner(x) from 0x8fda…6b53 succeeds, from 0xdead reverts 'AccessControl: account … is missing role'
- 0x8fda7f45b1427F2d4444F4c6D44D2B5d1cb46b53 is owner and DEFAULT_ADMIN_ROLE member 0, an EOA with nonce 1390 (probe)
- impl decompile: upgradeTo/upgradeToAndCall require role 0 (DEFAULT_ADMIN_ROLE)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,155 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Admin (role 0 holder) calls setSigner with a plain key, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
