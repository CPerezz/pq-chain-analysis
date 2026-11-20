---
id: ab7bbc4c-signer-upgrade-only
title: "0xab7bbc4c: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xab7bbc4cafba98131862c8d96e71d0343b9bc02b"
  family: "50c7bded0723bfa48e40c6a0f01095cd"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x0758a68f…, owner EOA 0x7f5ff301… (nonce 384)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0x0758a68f…, owner EOA 0x7f5ff301… (nonce 384)"
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

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0x54572dd38e3a23d980fb18cea255440107d73392, admin 0xf6658fb990244d14e94ab4469c2edd1a2320250c.
- transparent proxy (OZ v5), impl 0x54572dd3…; admin slot is 0x0758a68f… (the row says 0xf6658fb9…; chain state differs)
- eth_call ProxyAdmin.upgradeAndCall from 0x7f5ff301… succeeds; owner has no code, nonce 384
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
