---
id: ddb5ba35-fixed-signer
title: "0xddb5ba35: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xddb5ba3552ecabfc1893cdab9e46e5c5f86723f3"
  family: "54d5dc70955aea84849920f502e77922"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator/owner: redeploys the contract with a new signer and uses the owner sweep functions to move the funds."
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
  note: "I could not fully read 0xa93084ab from the decompilation. Rated MEDIUM because the owner sweep functions do not need a signature, so no funds stay stuck."
---

## Summary

The signer is the constant 0xd410…3d, which has no code today, and nothing can replace it. If that key's account gets real code, the signed deposit/claim functions stop working. The owner can still withdraw all ETH and tokens without a signature, so the result is a stopped function, not locked funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x8ff0018f: ECDSA recover followed by require(0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d == recovered, 'invalid signature') and require(arg1 > block.timestamp, 'deadline expired')
- The verified facts show 0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d is an EOA with 0 code bytes
- The only setters are transferOwnership/renounceOwnership, which write slot 0x33 (the owner), not the signer
- withdrawEther() is owner-only and transfers the full balance to the constant 0x518acaf4658ec61abe35b5566cff18c6f19cab9d. withdrawToken(address) is owner-only and sweeps a token's balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a replaceable signer (or one that accepts ERC-1271), then sweep the remaining funds with withdrawEther/withdrawToken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
