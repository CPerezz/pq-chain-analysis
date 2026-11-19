---
id: woreprivatesale-e617f172-fixed-signer
title: "WOREPrivateSale: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe617f1722955706bc487257439d9d61fd3a991a4"
  family: "f77cc2a5e25de99290827da711f662c3"
  name: "WOREPrivateSale"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 28873
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the admin ends the sale and withdraws"
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
  rating: MEDIUM
  note: "sale stops; nothing locked"
---

## Summary

`WOREPrivateSale` at `0xe617f1722955706bc487257439d9d61fd3a991a4`. Purchases need the presale signature of SIGNER, fixed in the constructor; a SIGNER with code ends purchases, but nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: WORE private sale: a purchase needs the presale list signature of SIGNER, a private address set in the constructor with no setter; the ETH raised is withdrawn by an admin's direct call. A SIGNER with…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: buy needs SIGNER's signature (private, set in the constructor, no setter).
- The raised ETH is withdrawn by an admin's direct call (withdraw()).
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $28,873 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The admin withdraws; a new sale contract if needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
