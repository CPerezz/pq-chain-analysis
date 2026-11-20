---
id: cd097b8d-fixed-gas-recovery
title: "0xcd097b8d: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59"
  family: "edcc1c0eaf550d1f1a1dd41e7df5a2f7"
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
  note: "Refuted for this address. The reviewer should consider scanning the factory's 17k children, which are the affected wallets."
---

## Summary

A factory that only CREATEs 2-signature wallets. The 3,072-gas call to 0x01 sits inside the embedded child code (CODECOPY of 0x486 bytes from 0x1e4) and never runs in the factory itself.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3072 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode 0x31d-0x322: PUSH2 0x0c00 STATICCALL lies within the 0x1e4-0x66a blob copied by CODECOPY at 0x1e0
- decompile: the fallback only checks selector 0x00968fe3, then CREATE and an event
- nonce 17,653 at the latest block: the deployed children carry the 3,072-gas ecrecover

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the factory; the deployed children need their own rows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
