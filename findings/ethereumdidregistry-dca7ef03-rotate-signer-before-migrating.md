---
id: ethereumdidregistry-dca7ef03-rotate-signer-before-migrating
title: "EthereumDIDRegistry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdca7ef03e98e0dc2b855be647c39abe984fcf21b"
  family: "554bb9ff9b8faf55c1e3dc72ec7d08c2"
  name: "EthereumDIDRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2325
  last_active: 2026-11-17
  recoveries_14d: 2126
fix:
  layer: account-migration
  who_acts: "each identity owner"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW holds by the account's own call (the owner is the key holder). I didn't re-check the source file line by line, and the RPC was unreachable."
---

## Summary

ERC-1056 EthereumDIDRegistry: the *Signed functions recover the identity owner; an owner that has code fails the signed path under EIP-8151.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner recorded for the identity (by default the identity itself); the owner can make every change by its own call and can hand the identity over. Read from source. Executed: a real transaction reverts with code at the signer.
- Row note (read from source): every change is open to the owner by its own direct call (changeOwner, setAttribute, addDelegate without Signed), and changeOwner hands the identity over to a new key
- Per-identity owner: the key holder itself is the guard party, so no admin is needed

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,325 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2,126 signature recoveries in the study's two-week trace window.

## Remediation

Owners whose account will take code use the direct functions, or changeOwner to a new key first.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
