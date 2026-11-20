---
id: nbean-e4c0fd77-signer-upgrade-only
title: "NBean: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe4c0fd77a9b85d508d70ec9fc4f6b6e36fa2256e"
  family: "7a5feed87321458a7ba955b5bbf8b073"
  name: "NBean"
  upgradeable: "yes"
  admin: "ProxyAdmin 0x89884fbf… owned by EOA 0x4890d247… (nonce 103)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "EOA 0x4890d247… via ProxyAdmin 0x89884fbf…"
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
  note: "Live admin: LOW."
---

## Summary

NBean ERC721A implementation behind transparent proxy 0x78edac08…. The whitelist mint signature is checked against the stored signer (set only in initialize); the proxy's ProxyAdmin is owned by a live EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: NBean checkWhitelistEligibility: the stored signer must sign the caller's address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source NBean.checkWhitelistEligibility: ECDSA.recover(...) == signer; signer is written only in initialize
- Proxy 0x78edac08… impl = 0xe4c0fd77, admin = 0x89884fbf…; ProxyAdmin owner() = 0x4890d2473Cb2642cbdC8a70159C3d195BE400Eb6 (no code, nonce 103)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade to an implementation with a signer setter; owner can airdrop meanwhile.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
