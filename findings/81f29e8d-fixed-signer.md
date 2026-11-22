---
id: 81f29e8d-fixed-signer
title: "0x81f29e8d: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x81f29e8d5a6f4f86755746c74393a1467b821d45"
  family: "db6bf23cbdbddf935486379ba0456ba1"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 37
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 7
  last_active: 2026-11-13
  recoveries_14d: 3
fix:
  layer: none
  who_acts: "owner 0x29de…0559"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The SAME act (moving the account's funds) stays open to the affected party by direct call, so LOW."
---

## Summary

This is a minimal ERC-4337 account whose stored owner has no setter. validateUserOp recovers the owner with ECDSA, so with code at the owner, UserOps fail. execute/executeBatch also accept a direct call from the owner, which works whatever the owner's code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: account with six selectors: one stored owner key and no function to change it. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: validateUserOp, execute(address,uint256,bytes), executeBatch, initialize(address,address), owner(), entryPoint(); there is no owner setter, and initialize reverts (already initialized).
- eth_call at block 26438999: execute(owner,1,0x) from the owner succeeds, but from 0x…01 it reverts 0x30cd7471. So execute accepts the owner or the EntryPoint.
- Owner 0x29de…0559 has no code; the account holds 0.0198 ETH.

## Impact and exposure

- Value held at block 26,438,999: $37 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 7 transactions called it in the 90 days before that block; last on 2026-11-13.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls execute directly from its migrated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
