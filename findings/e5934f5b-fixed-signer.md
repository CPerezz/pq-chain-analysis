---
id: e5934f5b-fixed-signer
title: "0xe5934f5b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe5934f5bd8fc519ebf823be56e27465bcbab32bd"
  family: "a79749106b44de2c418e68959aabed9b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Contract operator (owner store_a and profiter store_b)"
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
  note: "The decompiled code does not match the study note's description of a presale with signed deposit and claim. No user-deposit path is visible, so it is rated MEDIUM: only a function stops and nothing is locked."
---

## Summary

The signer is a constant (0x933e…), has no code today and has no setter, so the claim holds. If that key's account gets code, only the owner's signed transferFrom functions stop working. Funds held by the contract can still be withdrawn by store_b without a signature, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The 'v9' check in 0xf03ea4f5 and 0x19210419 compares the recovered address to the constant 0x933e5a768e631ca3d8f61d2b52353d103a4e1626.
- Row facts: the constant 0x933e… has code_bytes 0 and is not delegated.
- No function writes the signer; the only storage setters are 0xf2fde38b (slot 0), 0x6dc89061 (slot 1) and 0xf0c47fa8 (slot 3).
- withdraw and withdrawAll (store_b only) move tokens out with no signature; 0x42d0aff9 and 0xc73f360e do the same for ETH.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the 0x933e… key's account as an EOA, or a 7702 delegation at most, and never give it real code. Otherwise redeploy the contract with a replaceable signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
