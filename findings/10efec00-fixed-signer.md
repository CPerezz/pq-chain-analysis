---
id: 10efec00-fixed-signer
title: "0x10efec00: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x10efec00f45f918c1f7095306c5f84a22b810023"
  family: "cad641f51da8b5f41942ebff680aa0b3"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 397
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-09-27
fix:
  layer: new-deployment
  who_acts: "owner/project"
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
  note: "The study note calls this a presale with deposit and claim. The code shows an NFT mint: the signature gates only the paid First Edition mint of new tokens. The presale function 0xb3faa702 decompiles as a view with no signature check."
---

## Summary

The First Edition mint requires a signature from a signer address hard-coded in the bytecode. That address is an EOA today and no function can change it. If the key's account gets real code, only the signed First Edition mint stops. Nothing held is locked: the public mint and withdrawFunds do not use the signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- 0xc6a7c781: require(address(var_s) == 0x574a21f35c9b949836379d78bf77e8e6f11a72e3, "Invalid notice!")
- The signer is a bytecode literal and is an EOA (no code) at block 26438999
- No setter for the signer exists; transferOwnership only sets the owner in slot 8
- withdrawFunds() is owner only and needs no signature

## Impact and exposure

- Value held at block 26,438,999: $397 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-27.

## Remediation

Keep the signer key as a plain EOA (7702 delegation only), or deploy a new contract whose signer can be changed or which accepts ERC-1271 signatures. Users can still use the public mint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
