---
id: paymentchannels-a0fb83ad-own-signature-only-exit
title: "PaymentChannels: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xa0fb83ad673bb6f0c8ce0a0024451888dddb0e83"
  family: "f37d66ccf0e1a2b64767777737114dec"
  copies: 2
  name: "PaymentChannels"
  upgradeable: "no"
  rating: HIGH
  value_usd: 101416
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-17
fix:
  layer: new-deployment
  who_acts: "stakers unstake while their keys are EOAs"
evidence:
  level: source-read
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
  rating: HIGH
  note: "The notary keys this row was filed for rotate (the operator sets them), but a staker's unstake needs the staker's own signature and has no other path, so a staker whose account takes code leaves its WETH locked; no update path: HIGH, as for the SMG PaymentChannels 0xd60eea94. Not checked for this build: whether commitments are rechecked after others relied on them, which made 0xd60eea94 CRITICAL."
---

## Summary

PaymentChannels: notary keys checked by recovery; notaries set by operator.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker whose account takes code…. Read by hand.
- setStakeNotaryAddress/setClaimNotaryAddress onlyOperator
- operator (sole) 0xf7f991… EOA nonce 212, also both notaries (node block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $101,416 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-17.

## Remediation

operator sets new notary

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-own-signature-only-exit` applies, not `eip-8151-rotate-signer-before-migrating`; filed under it.
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
