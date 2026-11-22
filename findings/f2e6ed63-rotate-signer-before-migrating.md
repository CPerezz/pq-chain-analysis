---
id: f2e6ed63-rotate-signer-before-migrating
title: "0xf2e6ed63: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf2e6ed63bb255e51b64337c67fb4898aa979da6b"
  family: "b67e3771dca5f8e0800a8c490fc065b3"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  value_usd: 227735
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1573
  last_active: 2026-11-13
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE Safe 0xAAAa…aaA"
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
  note: "Live Safe admin (AccessControlEnumerable)."
---

## Summary

UUPS treasury with EIP-712 signed-order executor and ERC-1271 for role holders.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (grantRole, revokeRole, setForwarderConfigs, setRelayerExecutor). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setRouterSigner 0x945ae4ea role-gated; grantRole/revokeRole by role admins
- getRoleMember(0x00,0)=0xAAAaEE75…aaA, 2-of-3 Safe at block

## Impact and exposure

- Value held at block 26,438,999: $227,735 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,573 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Admin grants roles / sets new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
