---
id: da8151d9-signer-upgrade-only
title: "0xda8151d9: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xda8151d903cd1d4f3572bb16794214b538f35607"
  family: "77c8091b246880df8258db058535f6d4"
  copies: 9
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the operator (allowlisted keys)"
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
  rating: MEDIUM
  note: "No update path. Only the signed-order (1271) function dies; the operator's own funds stay movable by direct call: MEDIUM."
---

## Summary

A standalone operator trading contract (holds its own code, code hash 0xef4aeec7, 3 direct addresses, no proxy). Its ERC-1271 answer for the 1inch router recovers a signer and compares it with operator keys fixed in the code. The operators still move all funds by direct calls.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy answering for a signer fixed in its code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Family 77c8091b facts: code 0xef4aeec7… addresses 3, direct_addresses 3, so no proxy runs this code; the proxied copy 0x9c4dffb4… runs a different implementation, 0xce790c86…
- Dossier reading.first.json: isValidSignature compares with immutable allowlist constants; every state-changing function checks msg.sender against the same allowlist, no signature
- No EIP-1967 slots and no upgrade function at 0xda8151d9 (probe at 26438999); balance 0; txs.json: 24 recovery calls in the window

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator deploys a new contract with new keys and moves funds with the direct-call functions.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
