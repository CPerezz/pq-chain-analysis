---
id: 3954a5bf-rotate-signer-before-migrating
title: "0x3954a5bf: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3954a5bf350cb660a681152d7a30eb2124041f99"
  family: "f0fe62ff634308a36e3755385e9d6146"
  copies: 2
  upgradeable: "yes"
  admin: "Safe 0x3e9aa9cfa964e6ff0cc4598f1ee4fd75da4e01d4 (UPGRADER_ROLE + DEFAULT_ADMIN)"
  rating: LOW
  txs_90d: 4170
  last_active: 2026-11-18
  recoveries_14d: 181
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN Safe 0x3e9aa9cfa964e6ff0cc4598f1ee4fd75da4e01d4 on proxy 0x41dee1855293e4450cd67459047f372d4d818143"
evidence:
  level: executed
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
  note: "LOW: grantRole/revokeRole are callable by a live 2-of-n Safe that holds DEFAULT_ADMIN. Which role is checked by the recovery is not decoded, but all roles checked have admin 0x00."
---

## Summary

UUPS AccessControl implementation (unverified) used by proxy 0x41dee185…8143; signatures must come from a role holder. Under EIP-8151 a role-holder signer with real code stops verifying, so its signed calls revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole). Whoever holds it must replace it before that account takes code. Rule: stored-key. Executed: a real transaction reverts with code at the signer.
- Proxy 0x41dee185…8143 EIP-1967 implementation slot = 0x3954a5bf… at block 26438999 (cast storage)
- RoleGranted logs at creation (block 24589463): DEFAULT_ADMIN, UPGRADER_ROLE, PAUSER_ROLE, OPERATOR_ROLE and others to 0x3e9aa9cf…; role 0x10dac8c0… to EOA 0x8aa605bd… (nonce 10585)
- hasRole(0x00, 0x3e9aa9cf…) = true at block; getRoleAdmin of 0x10dac8c0… and UPGRADER_ROLE = 0x00
- 0x3e9aa9cf… is a Safe, getThreshold = 2

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 4,170 transactions called it in the 90 days before that block; last on 2026-11-18.
- 181 signature recoveries in the study's two-week trace window.

## Remediation

The admin Safe grants the signer role to a new key (grantRole) and revokes the old one before the old signer account takes code; it can also upgrade via UPGRADER_ROLE.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
