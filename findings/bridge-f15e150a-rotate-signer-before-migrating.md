---
id: bridge-f15e150a-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf15e150a8d4685b6466b2d07b644635ccfca8b11"
  family: "7764ca3b594e94169917d5a81bf41bde"
  copies: 2
  name: "Bridge"
  upgradeable: "no"
  rating: LOW
  value_usd: 10
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2521
  last_active: 2026-10-02
fix:
  layer: onchain-config
  who_acts: "0xaCa6…87D8 via 0x4809"
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
  note: "setter reachable via a live EOA default admin of the owner contract. Assumes 0x4809's forwarding function is gated by VALIDATOR_MANAGER_ROLE (from its ABI names, not decoded)."
---

## Summary

Bridge whose withdrawals are validated by a stored validator set and relayer.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (updateRelayer, updateValidatorSet). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- updateValidatorSet 0x61b786a1 and updateRelayer 0x9dbf5eca are onlyOwner in decompile
- owner() = 0x4809463301dea62bebf2afa086227eb95e386f22 at block 26438999: role-based admin contract (AccessControlDefaultAdminRules) exposing the same selectors, bridge() = this Bridge
- 0x4809 defaultAdmin() = 0xaCa6280bb93F4E80176895bE425e7e832fA687D8 (EOA, nonce 12); getRoleAdmin(VALIDATOR_MANAGER_ROLE) = DEFAULT_ADMIN_ROLE

## Impact and exposure

- Value held at block 26,438,999: $10 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,521 transactions called it in the 90 days before that block; last on 2026-10-02.

## Remediation

default admin grants VALIDATOR_MANAGER_ROLE if needed, then updates the validator set through 0x4809

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
