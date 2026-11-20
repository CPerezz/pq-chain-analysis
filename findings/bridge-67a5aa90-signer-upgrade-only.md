---
id: bridge-67a5aa90-signer-upgrade-only
title: "Bridge: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x67a5aa90efb317e0ca2c1a68abf5e67c1fb4822c"
  family: "559a2e4e66b046e069231fade380d9b2"
  copies: 3
  name: "Bridge"
  label: "Tricorn V1: Proxy Bridge"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xd4d47fa1…, whose owner is EOA 0x407dE7fb… (nonce 483)"
  rating: LOW
  value_usd: 3829
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0xd4d47fa1…, whose owner is EOA 0x407dE7fb… (nonce 483)"
evidence:
  level: source-read
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

Bridge: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: bridge requests must be signed by one stored signer address (read); no setter among its function names; the contract sits behind a proxy. Read by hand.
- Update path, read at block 26,438,999: proxy to 0x684d162a0ff24d13dd1a014dc7609d56fdd84160, admin 0xb8f1c1454da7e7551010ef2c0dab06c6a5cb4058.
- transparent proxy, impl 0x684d162a…; the EIP-1967 admin slot is ProxyAdmin 0xd4d47fa1… (the row says admin 0xb8f1c145…; chain state differs)
- eth_call ProxyAdmin.upgrade(proxy, impl) from owner 0x407dE7fb… succeeds; owner has no code, nonce 483
- txs_90d=0, value_usd=3829

## Impact and exposure

- Value held at block 26,438,999: $3,829 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
