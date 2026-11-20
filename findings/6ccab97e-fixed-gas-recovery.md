---
id: 6ccab97e-fixed-gas-recovery
title: "0x6ccab97e: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0x6ccab97ec94f8158fda451c5504db728adad7dc2"
  family: "dc93e0d8c1b557333790f379526655f1"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: this address never calls 0x01"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted for this address: a factory whose runtime never calls 0x01; the affected wallets are its children."
---

## Summary

A wallet factory: its runtime code only accepts selector 0x00968fe3 and creates a child wallet. The 3,072-gas STATICCALL to 0x01 the scanner found lies in the child code it copies, so this address itself never recovers a signature.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3072 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompiled runtime: the fallback requires selector 0x00968fe3, then CREATE(0, 0x80, ...) and an event; there is no other function
- nonce 1,169 at block 26,438,999: 1,168 children, which run the 3,072-gas wallet code and are filed with that family (0x5ee190e8, HIGH)
- the transferErc20/addOwner/removeOwner selectors the scanner saw belong to the copied child code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the factory; its children are covered by their own finding.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
