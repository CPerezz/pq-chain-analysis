---
id: ethbridge-d40ffe9b-fixed-signer
title: "EthBridge: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd40ffe9bfcc977051029c01f0fd4c93f10ed6413"
  family: "496eb5b12890594133571ccc9bb31aba"
  copies: 2
  name: "EthBridge"
  upgradeable: "no"
  rating: HIGH
  value_usd: 9238
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 15
  last_active: 2026-11-15
  recoveries_14d: 2
fix:
  layer: new-deployment
  who_acts: "the operator keeps the key without code, or moves users to a new deployment"
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
  rating: HIGH
  note: "bridged funds locked if CANISTER's address takes code"
---

## Summary

`EthBridge` at `0xd40ffe9bfcc977051029c01f0fd4c93f10ed6413`, with 1 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: EthBridge bridgeIn: the voucher must be signed by CANISTER, an address fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: bridgeIn releases funds only on a voucher signed by CANISTER, a constant; no setter.
- The owner's functions (feeWithdraw, withdrawDiscountToken) move fees and a discount token, not the bridged funds, so users bridging in have no other way.
- No proxy, no upgrade. 15 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $9,238 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 15 transactions called it in the 90 days before that block; last on 2026-11-15.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
