---
id: f1a2779b-fixed-signer
title: "0xf1a2779b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf1a2779b4578f1a5963bd0dca4f7ebe468b4c257"
  family: "5548400fb0c828f86a1c3ef3ae695284"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator (store_a and store_b) would have to deploy a new contract, or stop using the gated functions."
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
  note: "The study note calls this a presale whose deposit and claim need a signature, but the decompiled code shows no user deposit or claim functions. The signature only gates owner-only transfers, so I rated MEDIUM: a function stops and nothing is locked. The heimdall output is approximate, and I inferred that var_k is the ecrecover result from the require(memory[0x20]) pattern just before the check."
---

## Summary

The signer 0x933e…1626 is hard-coded and has no code today, so it is an EOA. Nothing can replace it, there is no code check, and ERC-1271 is not accepted. If that key ever gets real code, the two owner-only functions that pull tokens from store_b with a signature stop working. No funds get locked, because store_b's withdraw paths and the owner's transfer functions need no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_f03ea4f5: require(msg.sender == store_a) and then require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9") before transferFrom(store_b, arg1, arg2)
- Unresolved_19210419: the same "v9" check against the same constant
- Verified facts: 0x933e…1626 is an EOA with no code and is not 7702-delegated
- Neither setter, transferOwnership (store_d) nor 0x6dc89061 (store_c), touches the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed or that accepts ERC-1271, or keep the key 0x933e…1626 as a plain EOA. Until then, use the withdraw paths that need no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
