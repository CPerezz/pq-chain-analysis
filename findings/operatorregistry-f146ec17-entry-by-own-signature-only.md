---
id: operatorregistry-f146ec17-entry-by-own-signature-only
title: "OperatorRegistry: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0xf146ec17fae59b597cfc957e0cc7046d10d6f924"
  family: "3e7d66aaf2fd63325048933157336933"
  copies: 3
  name: "OperatorRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "operator (registers a watchtower without code)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Registration only; nothing held. LOW holds. Row says upgradeable yes, but this address is an uninitialised UUPS implementation (owner 0)."
---

## Summary

Witness Chain OperatorRegistry implementation: registerWatchtowerAsOperator requires the watchtower's own signature. Under EIP-8151 a watchtower with non-7702 code cannot be registered; no funds held.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: OperatorRegistry _validateWatchtowerRegistrationSignature: the watchtower must sign its registration; one with code cannot. Read (function text).
- src/core/OperatorRegistry.sol:72-80 recover == watchtower, called from :158-183; deRegister (:192) by operator msg.sender, no signature
- this address is the implementation: slot_0 = 0xff (initializers disabled), owner() = 0x0, getAllActiveOperators() = [] at 26438999; upgrades are onlyProxy/onlyOwner so nobody upgrades this address
- balance 0; no payable/withdraw path

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Register an EOA or 7702-delegated watchtower.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
