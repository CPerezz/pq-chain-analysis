---
id: c76d0e70-fixed-signer
title: "0xc76d0e70: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc76d0e70128ed20973c2c9f18dc9874c26c3a3f8"
  family: "bc64371d80f383f7439cf06f8655c544"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator must deploy a new factory."
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
  note: "The study note describes a presale with deposit and claim, but the decompiled code shows a collection factory. The rating is based on the factory code: only new creations stop, and no held funds are locked."
---

## Summary

The signer is a constant EOA, 0xf0d8…5041, compiled into the bytecode. No function can replace it, the code has no code-size check and no ERC-1271 fallback, and the contract cannot be upgraded. If this key's account gets real code, the signed collection-creation call stops working. No user funds are held, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Unresolved_ea20c988: `if (address(var_ah) == 0xf0d8c6284a1305fe5359cf26c194ce6fc6a05041)`, otherwise `revert("INVALID_SIGNATURE")`, after the OpenZeppelin ECDSA error checks
- Constant signWallet = 1374992007902974912671093877544715418581549994049, which is 0xf0d8c6284a1305fe5359cf26c194ce6fc6a05041
- Verified facts: 0xf0d8c6284a1305fe5359cf26c194ce6fc6a05041 is an EOA with no code
- The only setters are transferOwnership and renounceOwnership, which write the owner slot 0x33

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new factory with a signer that can be rotated, or one that accepts ERC-1271 signatures (e.g. via SignatureChecker).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
