---
id: d1a943fb-fixed-signer
title: "0xd1a943fb: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd1a943fb40ba23f9ae0003d675f12401f970eb5f"
  family: "c6f19d95e89b53daf1e49f73a4424d45"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator (owner/profiter)"
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
  note: "The study note calls this a presale with deposit and claim, but the decompiled code shows no user deposit or claim logic. It looks like an owner-run bot. The signed functions only move the operator's own approved tokens."
---

## Summary

The signer is a hard-coded constant, 0x933e…1626, that no function can change, and that address is an EOA today. If it ever gets real code, only the owner-run signed transferFrom functions stop working. The contract's balances can still leave through the profiter's withdraw functions, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xf03ea4f5: require(msg.sender == store_a, "o"), then require(address(var_k) == 0x933e5a768e631ca3d8f61d2b52353d103a4e1626, "v9"), then transferFrom(store_b, arg1, arg2)
- 0x19210419: the same "v9" constant check
- Verified facts: 0x933e5a768e631ca3d8f61d2b52353d103a4e1626 is an EOA (no code) at block 26438999
- The only setters are 0xf2fde38b (owner) and 0x6dc89061 (profiter). Neither touches the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the contract with a signer that can be changed, or one that also accepts ERC-1271 signatures. Until then, the profiter can move tokens directly instead of using the signed path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
