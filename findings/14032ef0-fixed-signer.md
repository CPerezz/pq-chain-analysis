---
id: 14032ef0-fixed-signer
title: "0x14032ef0: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x14032ef02c2b6e84c85a42db59db32192657bf68"
  family: "818861688873d1f1d4cd6b3026095445"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator: deploy a new proxy with a new signer and point the frontend at it."
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
  note: "owner() reads 0, so the contract looks uninitialized, and initialize() appears callable by anyone. This is a separate issue. It does not affect the rating, because no user funds are held. The study note's 'presale' label does not match the code."
---

## Summary

The signer is a hardcoded constant, nothing can replace it, and it is an EOA today (0 code bytes). If that address ever gets real code, callErc20 and callEth stop working. No user funds are held between transactions, so only the routing function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _validateSignature compares the recovered address to the literal 0xD410910E6CDEc5975Fa8D46e575Af3c3Ebb0ca3d
- constants[]: 0xd410... has code_bytes 0 and delegated false, so it is an EOA
- No function sets the signer, and there is no ERC-1271 or code check
- _beforeErc20 pulls the user's tokens with safeTransferFrom in the same transaction as the outgoing call, so no deposits are held

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new version that stores the signer with an owner-controlled setter, or that accepts ERC-1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
