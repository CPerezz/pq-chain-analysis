---
id: paymentchannels-affa8300-own-signature-only-exit
title: "PaymentChannels: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1"
  family: "f37d66ccf0e1a2b64767777737114dec"
  copies: 2
  name: "PaymentChannels"
  upgradeable: "no"
  rating: HIGH
  value_usd: 101366
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-17
fix:
  layer: account-migration
  who_acts: "each party acts before its address takes code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "stakers' own stakes locked if their address takes code"
---

## Summary

`PaymentChannels` at `0xaffa8300d0e0ae1fbe140e1a74de31a64c78f6c1`, with 1 more addresses running its code. It releases a party's funds or rights only on that party's own ECDSA signature; once the party's account has code, they are locked.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker whose account takes code…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment, next to the notary's; no other path takes a stake out.
- addOperator manages operators, not stakers' keys. No proxy, no upgrade. 1 transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $101,366 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-17.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
