---
id: 27cfa763-signed-shortcut-lost
title: "0x27cfa763: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x27cfa763272f561ccae1a4d17800d0db78f91719"
  family: "a327e279d96cc7ab403b6b3558ca320a"
  upgradeable: "no"
  rating: LOW
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "users call their targets directly"
evidence:
  level: source-read
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
  note: "A relay hub that forwards meta-transactions for whichever user signed: a user whose account has code loses only the relayed route and acts directly instead: LOW."
---

## Summary

Not a Gemini custodian. Standalone any.sender-style relay hub: forwards a meta-transaction on behalf of a caller-named signer and checks 'Signer did not sign this meta-transaction'. It has no owner, no fixed key, no storage key setter and holds no funds.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode strings: 'Signer did not sign this meta-transaction', 'Meta-transaction failed', replay-protection strings; no init/owner selector (selectors 2eae259d, 8ad0a9d7, getChainID, nonceStore)
- no CALLER, DELEGATECALL or STATICCALL opcode in the decoded runtime; facts list no setters, exits or getters

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain. A signer whose address gains code loses this relay path and acts directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-signed-shortcut-lost` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
