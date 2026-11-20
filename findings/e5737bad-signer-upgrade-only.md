---
id: e5737bad-signer-upgrade-only
title: "0xe5737bad: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe5737bad730fce4ef0a5de95a817f4df267c5d4a"
  family: "47bd7fc2ff06805790a7b010d26d2e84"
  copies: 2
  upgradeable: "yes"
  admin: "admin contract 0x30d6d705… owned by EOA 0x5C27e701… (nonce 76)"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "EOA 0x5C27e701… via admin contract 0x30d6d705…"
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

Relay hub implementation (relayCall/canRelay/penalize*/stake) behind transparent proxy 0x21b004f8…, whose admin contract is owned by a live EOA.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Proxy 0x21b004f8… impl = 0xe5737bad, admin = 0x30d6d705…; balance 0.01 ETH (dossier state)
- Admin 0x30d6d705… owner() = 0x5C27e70195d7010B0805c8dA113DF41F793b4AC9 (no code, nonce 76)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Upgrade the proxy to an implementation with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
