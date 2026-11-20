---
id: 00000000-signer-upgrade-only
title: "0x00000000 (tagged Rhinestone: Hook): signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000000000f6ed8be424d673c63eeff8b9267420"
  family: "db120d1452954de78e91e8f8ce8487d0"
  label: "Rhinestone: Hook"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xea477f5f…, owner EOA 0x9568B5E0… (nonce 13)"
  rating: LOW
  txs_90d: 270
  last_active: 2026-11-15
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0xea477f5f…, owner EOA 0x9568B5E0… (nonce 13)"
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
  note: "live EOA controls the ProxyAdmin"
---

## Summary

contract: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x69b80e6ca11554ea6834b032068932c1cbace9be, admin 0xea477f5fe222f7c644624232d5822c67fe25dd3b.
- transparent proxy (OZ v5), impl 0x69b80e6c…, admin slot 0xea477f5f…
- eth_call ProxyAdmin.upgradeAndCall(proxy, impl, '') from 0x9568B5E0… succeeds; owner has no code, nonce 13
- txs_90d=270, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 270 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
