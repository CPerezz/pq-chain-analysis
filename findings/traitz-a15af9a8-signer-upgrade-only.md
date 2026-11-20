---
id: traitz-a15af9a8-signer-upgrade-only
title: "Traitz: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xa15af9a878db51eb9b24591890ec4742c36feb88"
  family: "2a0e98941ae7eafa74253534aada4d40"
  name: "Traitz"
  label: "deployed by Kubz: Deployer"
  upgradeable: "yes"
  admin: "EOA 0x759c5F293EdC487aA02186f0099864Ebc53191C1 via ProxyAdmin 0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "owner 0x759c5F293EdC487aA02186f0099864Ebc53191C1 (EOA, nonce 1780) via ProxyAdmin; proxy owner EOA nonce 2429 also live"
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
  note: "Live, very active EOA admin — LOW."
---

## Summary

Traitz: signature must recover to the stored signerAlt. Behind a live TransparentUpgradeableProxy with a real, active admin chain.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the recovered address must be the stored signerAlt. Read from source.
- Update path, read at block 26,438,999: erc6551AccountImplementation(), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- node, block 26438999: proxy 0xdc7411d597111c83d7bcbc7c7523e9b2cd22c9eb, eip1967 implementation = 0xa15af9a878db51eb9b24591890ec4742c36feb88 (matches, live), admin = 0xf025a72ed25c5d24a0179c93a75ca74a9fa5744c (nonce 1), owner of that admin = EOA 0x759c5F29... nonce 1780
- node: proxy's own owner() = EOA 0x6C8Ee01F... nonce 2429, balance 8.3 ETH — both admin chain and app owner are highly active

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Admin upgrades the proxy to an implementation with a replaceable signerAlt.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
