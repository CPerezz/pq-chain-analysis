---
id: d871c03d-custody-wallets-fixed-signers
title: "0xd871c03d: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e"
  family: "c8330e19b6b243e08158ce45883a5cfb"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 36271820
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14
  last_active: 2026-11-10
fix:
  layer: new-deployment
  who_acts: "the custodian moves funds to wallets it can change before its signers take code"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-custody-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "signers and threshold read; all EOAs today; no setter, no upgrade path"
---

## Summary

Contract `0xd871c03dd4e1ce40b51280ce58c6450b2e060d2e`, with 1 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 2 wallets holding 20,100 ETH: a loop of recoveries compared with stored signers (getSigners, THRESHOLD); no function name that changes them. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (15,967 bytes, no verified source) exposes getSigners, THRESHOLD, blockNonce, isNonceUsed: a multisig with a loop of recoveries over stored signers. No function changes them; no proxy slot, no upgrade function.
- State at block 26,438,999: 8 signers, all EOAs today, THRESHOLD 4, so it locks once 5 of the 8 signers take code.

## Impact and exposure

- Value held at block 26,438,999: $36.3M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
