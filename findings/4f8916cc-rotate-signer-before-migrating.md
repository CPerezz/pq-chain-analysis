---
id: 4f8916cc-rotate-signer-before-migrating
title: "0x4f8916cc: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4f8916cc1d9307364f0343e0a1e9c658b79daa46"
  family: "c82dcacd03d3f18f5a643a1d213d8082"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 1373
  last_active: 2026-11-18
  recoveries_14d: 132
fix:
  layer: onchain-config
  who_acts: "defaultAdmin Safe 0x6c539E15 (1-of-2)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The live Safe default admin can rotate signer roles. Bytecode-level reading."
---

## Summary

Unverified contract (family c82dcacd), AccessControlDefaultAdminRules with operator and signer-operator roles. Signed calls require a recovered signer holding the signer role. Under EIP-8151 a signer with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantOperatorRole, grantRole, grantSignerOperatorRole, revokeOperatorRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall: grantSignerOperatorRole/grantOperatorRole are gated by the operator role plus the store_m role; store_m=0x0 (DEFAULT_ADMIN_ROLE) at 26438999
- defaultAdmin()=Safe 0x6c539E15; isOperator(Safe)=false, but getRoleAdmin(OPERATOR_ROLE)=getRoleAdmin(SIGNER_OPERATOR_ROLE)=0x0, so the Safe can grantRole either directly (0x2f2ff15d)
- Safe 1-of-2 owners [0xc3D5F0B5, 0x4F10405E] (probe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,373 transactions called it in the 90 days before that block; last on 2026-11-18.
- 132 signature recoveries in the study's two-week trace window.

## Remediation

The Safe grants itself OPERATOR_ROLE or grants SIGNER_OPERATOR_ROLE to a fresh EOA via grantRole, and revokes the old key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
