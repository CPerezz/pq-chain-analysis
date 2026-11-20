---
id: d163cc01-fixed-signer
title: "0xd163cc01: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd163cc010f8f8c0c63567c43737f562b21945050"
  family: "89cf5a51fc587a738256959d9332e90c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner or project: they would have to deploy a new contract, or keep the signer key code-free (EOA or 7702 delegation only)."
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
  note: "The signer address is the same as the current owner(), but the comparison uses the bytecode literal, not the owner slot. The signed functions only change cosmetic token traits."
---

## Summary

The signer is a constant in the bytecode, 0x923a…ba30, and that address is an EOA today. Nothing can replace it and there is no ERC-1271 path. If that key's account gets real code, the five signed trait-change functions stop working. No funds get locked, because the owner can still withdraw mint ETH without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0x37127fed, 0x4e58ef6c, 0x7138f55b, 0x82bd57a0 and 0xc465d084 all contain the ECDSA error strings and `require(.. == 0x923a9eae85e8c61083bd984285b72edf4113ba30, CustomError_8baa579f())`
- Verified facts: 0x923a9eae85e8c61083bd984285b72edf4113ba30 is an EOA (no code)
- f2fde38b transferOwnership writes only slot 1 (owner); there is no function that sets the signer
- 0x3ccfd60b withdraw: onlyOwner, `payable(store_m).transfer(address(this).balance)`, no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key free of non-delegation code. If it ever gets code, redeploy with a signer that can be updated and/or an ERC-1271 path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
