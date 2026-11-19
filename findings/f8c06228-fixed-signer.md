---
id: f8c06228-fixed-signer
title: "0xf8c06228: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf8c0622839ef0d2bbdc11954e6e129c668ec2288"
  family: "03dc9c4f599b498ba989f8613b5ce430"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 87070
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-25
fix:
  layer: new-deployment
  who_acts: "the owner deploys a new allowlist mint"
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
  rating: MEDIUM
  note: "signed mints stop; nothing locked"
---

## Summary

Contract `0xf8c0622839ef0d2bbdc11954e6e129c668ec2288`. An NFT mint whose allowlist signer looks fixed: a signer with code ends allowlisted mints, but nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: NFT mint allowlist (48 ETH of mint proceeds, owner 0xba5edab6…): the allowlist signer looks fixed; the owner's own functions are direct. A signer with code ends signed mints; nothing is locked. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode and names: the allowlist signature is checked against a stored signer with no setter.
- The owner (0xba5edab69ffb71052bd34311ce41d145a5dff6bb) withdraws mint proceeds by direct call; NFT transfers are unaffected.
- No proxy, no upgrade. 2 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $87,070 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

A new mint contract or a public mint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
