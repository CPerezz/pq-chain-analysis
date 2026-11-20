---
id: 5cdf9fa2-fixed-signer
title: "0x5cdf9fa2: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x5cdf9fa20a9f60f090799d336a0a47de458014c7"
  family: "5b3f8b1f1bbd03fc8bf2755e0eeca1d1"
  copies: 156
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  verdict: refuted
  rating: NONE
  note: "Every path that reaches the check is closed for good by time; the funds leave through the signature-free refund()."
---

## Summary

This is an HTLC-style token escrow. The signed withdraw (signature from the constant 0x16c1…1077, plus a sha256 preimage) needs block.timestamp < lockTime 1742769900 (2025-03-23). That time has passed, and refund() to the fixed `from` address needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 156 contracts: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile of the dossier's code.hex: withdraw has require(0x67e08eec > block.timestamp, TooLate), then ECDSA recover == 0x16c1c9f1abcf2ba9e8d853827339dbeceaa91077
- refund (0x590e1ae3) has require(0x67e08eec <= block.timestamp), with no signature; it pays the token balance out
- lockTime is a constant in the code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 156 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
