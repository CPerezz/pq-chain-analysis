---
id: riskenginev2-00000000-signer-upgrade-only
title: "RiskEngineV2: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x000000000000ffada7c641e2ad6b13b51b50cc94"
  family: "eb30b481a964bedad3e976d38e8bd5ed"
  copies: 2
  name: "RiskEngineV2"
  upgradeable: "yes"
  admin: "EOA 0xe3c7c311cc449baa6d917cbb807640e00479c308 owned by Safe 0x8dfeaa4aee4596b90ef581d7731e4e0b7aba3221 (3/5)"
  rating: LOW
  txs_90d: 1289
  last_active: 2026-11-18
fix:
  layer: contract-upgrade
  who_acts: "3-of-5 Safe 0x8dfeaa4a… via EOA admin 0xe3c7c311…"
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
  note: "Live multisig admin chain: LOW."
---

## Summary

BuilderWallet isValidSignature: SignatureChecker on the stored builderAdmin, behind an upgradeable proxy.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: BuilderWallet isValidSignature: SignatureChecker on the stored builderAdmin. Read (function text).
- Update path, read at block 26,438,999: proxy to 0x000000000000f7d509a1583a2947059683137bca, admin 0xe3c7c311cc449baa6d917cbb807640e00479c308.
- EIP-1967 admin slot at 26438999 = 0xe3c7c311cc449baa6d917cbb807640e00479c308 (1361 bytes, nonce 1); its owner() = 0x8dfeaa4a…
- 0x8dfeaa4a… is a Safe: getThreshold=3, 5 owners, all with real activity (nonces 11, 1, 3, 163, 51)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,289 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Upgrade to an implementation with a new builderAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
