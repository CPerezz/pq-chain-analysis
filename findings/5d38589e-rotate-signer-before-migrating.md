---
id: 5d38589e-rotate-signer-before-migrating
title: "0x5d38589e: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d38589e9574df1abe4b85cab7a870c285cd23c3"
  family: "69fc694fa935591a1f4a5bea05f5fa4d"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1838
  last_active: 2026-11-17
  recoveries_14d: 1836
fix:
  layer: onchain-config
  who_acts: "defaultAdmin Safe 0x6272D4a4 (2-of-3)"
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
  note: "The default admin is a live Safe holding DEFAULT_ADMIN_ROLE, and grantRole/revokeRole are present. Bytecode-level reading only."
---

## Summary

Unverified contract (family 69fc694f) using AccessControlDefaultAdminRules. Its ECDSA-signed path checks a role-held or stored validator key. Under EIP-8151 a validator with code is rejected.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, setValidator, setWithdrawOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- heimdall: OZ grantRole (0x2f2ff15d) and revokeRole present; setWithdrawOperator present; ECDSA 'invalid signature' path
- defaultAdmin()=Safe 0x6272D4a4, hasRole(0x0, Safe)=true at 26438999; Safe 2-of-3 (probe)
- getRoleAdmin(keccak VALIDATOR_ROLE)=0x0; the role id the recovery checks was not resolved from the bytecode

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,838 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1,836 signature recoveries in the study's two-week trace window.

## Remediation

The Safe grants the validator role or sets a fresh EOA validator and revokes the old one.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
