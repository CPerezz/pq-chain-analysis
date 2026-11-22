---
id: 8c33d309-custody-wallets-fixed-signers
title: "0x8c33d309: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8c33d309157553d69413d98ea853424689c0c2b1"
  family: "051d356810ecba1609f75aab780c552a"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 9739334
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3514
  last_active: 2026-11-18
  recoveries_14d: 1098
fix:
  layer: new-deployment
  who_acts: "the custodian moves funds to wallets it can change before its signers take code"
evidence:
  level: executed
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
  note: "threshold read; owners not enumerable; no setter, no upgrade path"
---

## Summary

Contract `0x8c33d309157553d69413d98ea853424689c0c2b1`, with 1 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 2 multisig wallets holding 5,397 ETH, 1,098 recoveries in the window: ordered owner signatures (isOwner, threshold, execute); no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (4,808 bytes, no verified source) exposes execute(uint8[],bytes32[],bytes32[],bytes), isOwner, nonces, fullNonce, threshold: owners' ordered signatures over a call. No function changes owners or threshold; no proxy slot, no upgrade function.
- State at block 26,438,999: threshold 3; the owners sit in a mapping with no list getter, so how many must take code before it locks is not read here.
- Busiest of the custody rows: 3,514 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $9.7M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,514 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,098 signature recoveries in the study's two-week trace window.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
