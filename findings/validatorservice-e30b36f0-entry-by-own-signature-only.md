---
id: validatorservice-e30b36f0-entry-by-own-signature-only
title: "ValidatorService: entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0xe30b36f0527d16fb692a2c4804c50e53f83add1c"
  family: "7b96ff89f397d24c0e031ea76859ce9c"
  name: "ValidatorService"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "validator (links a node address without code)"
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
  note: "Registration of an operational key only; nothing held. LOW holds (address is an unused implementation)."
---

## Summary

SKALE ValidatorService implementation: linkNodeAddress requires the node address to sign the validatorId. Under EIP-8151 a node address with non-7702 code cannot be linked; validator stake and delegations do not depend on it.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: SKALE ValidatorService linkNodeAddress: the node address named must sign to be linked. Read (function text).
- contracts/delegation/ValidatorService.sol:265-275 linkNodeAddress: recover(sig) == nodeAddress; unlinkNodeAddress (:283) needs no signature
- state at 26438999: all storage slots zero, balance 0; facts: 1 address runs this code, directly (not behind a proxy), 0 txs in 90 days — an uninitialised implementation
- no other ecrecover in the dossier sources

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Link an EOA or 7702-delegated node address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
