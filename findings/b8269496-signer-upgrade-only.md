---
id: b8269496-signer-upgrade-only
title: "0xb8269496: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xb8269496f37a7e5385c3cf597a3226b96eaf0ea0"
  family: "50073d83fe75e77960d2c11898535801"
  copies: 2
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "The row address itself is an uninitialized implementation holding nothing. The facts say one proxy runs it, but that proxy was not identified."
---

## Summary

Uninitialized singleton of a single-owner Safe-like wallet (setup(owner) never called here: slots 0-2 zero). Its execTransaction supports DELEGATECALL, so a wallet running it can rewrite its own owner.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xb8269496f37a7e5385c3cf597a3226b96eaf0ea0: no admin, no upgrade function in the implementation.
- state.json @26438999: slot_0, slot_1 (owner), slot_2 all zero; balance 0; no proxy slot
- heimdall: setup(address) one-time sets owner in slot 1; isOwner compares slot 1; getOwners/getThreshold/execTransaction present, no add/swapOwner
- scanner: DELEGATECALL with calldata target (pc 938) and 3 ecrecover sites (eq_storage)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. A wallet using it can change owner through a signed delegatecall before migrating.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
