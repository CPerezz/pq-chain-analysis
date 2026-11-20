---
id: ethernalelves-be55abfc-signer-upgrade-only
title: "EthernalElves: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbe55abfcd0bc8863a7472a735e7001509ff0b7b8"
  family: "15ec8adc586069d2bdbcd9a3656e1297"
  name: "EthernalElves"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x7779f54e…, owner EOA 0xe7AF7762… (nonce 748)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "ProxyAdmin 0x7779f54e…, owner EOA 0xe7AF7762… (nonce 748)"
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

EthernalElves: the signer is one key in storage with no setter; EIP-8151 makes ecrecover return nothing once that key holds real code, so the signed function stops working until the code is upgraded.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: PrismBridge _isSignedByValidator: the stored validator must have signed. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x6df94b08eada7ca46f263a8acce93b795eedfc6a, admin 0x7779f54e74fd020f25679d9af568e5ca9eed7901.
- transparent proxy, impl 0x6df94b08…, admin slot 0x7779f54e…
- eth_call ProxyAdmin.upgrade(proxy, impl) from 0xe7AF7762… succeeds; owner has no code, nonce 748
- txs_90d=0, value_usd=None

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

the upgrade holder deploys an implementation whose signer check accepts the new key (or ERC-1271) and upgrades before the signer gains real code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
