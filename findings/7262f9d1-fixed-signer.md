---
id: 7262f9d1-fixed-signer
title: "0x7262f9d1: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7262f9d1d4d87d850273f5b8a61dfee2e6f509b1"
  family: "6284c348a1199e1b15d6418ae200aff9"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-10-20
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new hook with a new signer and points the relay gate at it."
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
  note: "The study note calls this a presale with deposit and claim functions, but the verified source is a CyberID relay hook. The row's exit list (transfer, transfer_attention_tg_…) also does not match this source. The verdict is based on the verified source together with the `signer()` getter, which does match."
---

## Summary

The signer is immutable and has no setter. Its address, 0xb6f5…a098, has no code today (EOA). If that account gets real code, signed CyberID registrations through this hook stop working. No funds are held or locked, so only this function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` is assigned only in the constructor.
- `_requiresExpectedSigner` compares the raw `ecrecover` result to `signer`. There is no code check and no ERC-1271 fallback.
- On-chain `signer()` returns 0xb6f53fcf8a8f9e2b9d7c5fcf1d6d052496e8a098, an EOA with no code at block 26438999.
- `_chargeAndRefundOverPayment` forwards msg.value in the same call, so there are no user balances.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-20.

## Remediation

Deploy a new hook with a signer that can be replaced, or one that accepts ERC-1271 signatures, and reconfigure the relay gate to use it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
