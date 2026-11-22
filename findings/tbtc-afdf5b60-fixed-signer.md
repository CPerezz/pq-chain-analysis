---
id: tbtc-afdf5b60-fixed-signer
title: "DepositRedemption: signer fixed in code"
project: tbtc
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xafdf5b603f07cf664e44f3896bb2f0047d330ba4"
  family: "ef83389f8488b7b83bc903c63440b0f8"
  copies: 4306
  name: "DepositRedemption"
  upgradeable: "no"
  rating: HIGH
  value_usd: 234572
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-11-02
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
  note: "signing group key fixed per deposit; deprecated system"
---

## Summary

`DepositRedemption` at `0xafdf5b603f07cf664e44f3896bb2f0047d330ba4`, with 4,305 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: tBTC v1 CheckBitcoinSigs: the recovered address must be the address of the signing group's public key; used for the redemption signature and as proof of a fraudulent signature. Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read (tBTC v1 CheckBitcoinSigs): the recovered address must be that of the deposit's signing group public key, fixed when the deposit is made.
- The 4,306 deposits are fixed delegates to the DepositRedemption library code; no upgrade.
- 1 transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $234,572 (ETH and 49 priced tokens, over 4,306 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
