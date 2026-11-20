---
id: crosschaintoken-93a9f386-signer-upgrade-only
title: "CrossChainToken: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x93a9f386226ca86f15084f0149f4fc5d7edd0230"
  family: "95cc6d94b398acc899b114df72feaf18"
  name: "CrossChainToken"
  upgradeable: "yes"
  admin: "the contract's owner EOA (see proxyprobe)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "the contract owner (EOA)"
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
  note: "An EOA owner with nonce 0 still has a working private key and a live upgrade path — nonce 0 only means it hasn't sent a transaction itself, it doesn't disqualify it as a signer/owner."
---

## Summary

CrossChainToken (a scam-style 'attention_tg_invmru' token): owner() is a live EOA (has real code = 0x, i.e. a normal key-controlled account) that can call upgradeTo/upgradeToAndCall even though it has sent no transactions of its own yet.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (upgradeTo, upgradeToAndCall). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: upgradeTo(address), but owner() is zero or absent. 1 with an upgrade function whose caller was not read.
- node, block 26438999: owner() on this address = 0x0...0, but that is the implementation's own storage (uninitialized); the live proxy's owner() (per proxyprobe) = EOA with code=0x, nonce=0
- batch facts: upgrades=[upgradeTo(address), upgradeToAndCall(address,bytes), ...], setters=[transferOwnership(address)]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls upgradeTo.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
