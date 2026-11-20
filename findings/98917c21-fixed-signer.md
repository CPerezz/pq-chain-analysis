---
id: 98917c21-fixed-signer
title: "0x98917c21: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x98917c210cd8e751846446f25b8618753cfd3f75"
  family: "7584071b6abe3822dd2403c95b1076f0"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator (owner/profiter) deploys a new contract with a new signer"
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
  note: "The study note's 'presale' label does not match the code: there are no user deposits or claims. The signed path is owner-only and moves the operator's own approved tokens."
---

## Summary

The signer is a hardcoded constant EOA that no function can replace, and there is no code or ERC-1271 check. Losing it only disables the owner's signed transferFrom from store_b. The tokens stay in store_b's wallet, and store_b can still withdraw the contract's own balance without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xf03ea4f5: require(msg.sender == store_a, "o"); require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9"); then transferFrom(store_b, arg1, arg2)
- 0x19210419: same v9 check against the same constant, then transferFrom(store_b, ...)
- Verified facts: 0x933e5a76...1626 is an EOA with no code; constants[].delegated is false
- No function writes the signer; transferOwnership only writes slot 0 (store_a)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed, or accept ERC-1271 signatures; otherwise the operator can move its tokens directly from the store_b wallet.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
