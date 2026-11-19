---
id: litesig-4bc3c926-fixed-signer
title: "LiteSig: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4bc3c92673d06688c865248c6696ea7c52d1710e"
  family: "c0b0a4429eeb8cf6391515f545089810"
  copies: 3947
  name: "LiteSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 84161
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "owners fixed; no upgrade"
---

## Summary

`LiteSig` at `0x4bc3c92673d06688c865248c6696ea7c52d1710e`, with 3,946 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: LiteSig: the required number of owners must sign in ascending order; owners are set at initialisation and no function changes them (submit read). Read by hand.
- Update path, read at block 26,438,999: proxy to 0x141a01b4ec8e9424dec5b866c0f580d552007ac5: no admin, no upgrade function in the implementation.
- Read by hand (LiteSig submit): the required number of owners must sign in ascending order; owners are set at initialisation; no function changes them.
- The 3,947 addresses are proxies to 0x141a01b4ec8e9424dec5b866c0f580d552007ac5 with no admin and no upgrade function.
- Dormant.

## Impact and exposure

- Value held at block 26,438,999: $84,161 (ETH and 49 priced tokens, over 3,947 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
