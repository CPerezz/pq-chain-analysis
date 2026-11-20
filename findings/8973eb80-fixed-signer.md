---
id: 8973eb80-fixed-signer
title: "0x8973eb80: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8973eb80bb357ff59c12959c5249f7961a521859"
  family: "c9dae59828e749810e7a5cbc38694a40"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator (owner/store_b)"
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
  note: "The study note's 'deposit and claim' signature path is not visible in the decompiled code; the signed functions are owner-only. 0x496e...6365 is ASCII 'Insufficient balance', not an address."
---

## Summary

The signer is a hardcoded constant that is an EOA today, and nothing can replace it. If its account gets code, only the owner's signed transferFrom functions stop working. Funds stay in store_b's wallet or can be withdrawn by store_b, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_f03ea4f5 and Unresolved_19210419: require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9")
- Both also require msg.sender == store_a and then call transferFrom(store_b, ...)
- No function writes the signer; transferOwnership only writes store_a
- 0x933e...1626 has no code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be changed, or have the owner use the transfer functions that need no signature (e.g. fea2b220 / batchTransfer).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
