---
id: luckymoney-e93577cf-signer-upgrade-only
title: "LuckyMoney: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe93577cf0590c3cd7eceb6cb68d84b2a717c15bb"
  family: "37f74ed88406f54f7a1e038d45d4df98"
  name: "LuckyMoney"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xbeefe81b… owned by EOA 0x91aB414B… (nonce 66)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "EOA 0x91aB414B… via ProxyAdmin 0xbeefe81b…"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live admin, and nothing is locked: LOW."
---

## Summary

LuckyMoney implementation behind transparent proxy 0x43bf78a8…. A collector's submit needs the packet creator's signature; the signer is each packet's creator, not one fixed key. After expiry, distribute() pays the collectors and returns the rest to the creator.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: LuckyMoney submit: the packet's creator must sign the collector's claim / SyntheticPunks.recoverSigner: returns the signer. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source submit(): recoverSigner(hash, signature) == l.creator; distribute() is open to anyone once full or expired and refunds the remainder to the creator
- Proxy 0x43bf78a8… impl = 0xe93577cf, admin = ProxyAdmin 0xbeefe81b…, owner() = 0x91aB414BeBb3F86b5708051042B03141f660C13a (no code, nonce 66)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade if needed; a migrating creator's open packets refund at expiry.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
