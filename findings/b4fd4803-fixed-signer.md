---
id: b4fd4803-fixed-signer
title: "0xb4fd4803: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb4fd48038f0ad22155497f182052c94ab851c596"
  family: "242a7b0b19f76460a98094e5139f60c4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner, by deploying a new contract and sweeping the balances with the withdraw functions"
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
  note: "The decompilation of the signature functions is partial, but the constant comparison and the \"invalid signature\" check are clear."
---

## Summary

The signer is a hardcoded constant EOA, and nothing can replace it or check it through ERC-1271. If that key's account gets code, the signed deposit/claim calls stop working. The owner can still withdraw all ETH and tokens, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_8ff0018f: require(0xd410910e6cdec5975fa8d46e575af3c3ebb0ca3d == recovered, "invalid signature")
- 0xd410…ca3d is an EOA (code_bytes 0)
- The only setter is transferOwnership, which writes the owner slot 0x33
- withdrawEther and withdrawToken are onlyOwner; ETH goes to 0x518acaf4… (an EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be replaced or that supports ERC-1271. The owner withdraws the remaining balances.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
