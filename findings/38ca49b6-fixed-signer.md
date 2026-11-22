---
id: 38ca49b6-fixed-signer
title: "0x38ca49b6: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x38ca49b6dfa820bca917a60995cc07b88db7dc4d"
  family: "f630ae8fc87573bd93ae665a4158d5ae"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 27
  last_active: 2026-10-11
fix:
  layer: new-deployment
  who_acts: "The project/owner would have to deploy a new mint contract. Payees can still call release() themselves."
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
  note: "The decompiled code shows an NFT mint, not a deposit/claim presale. Only the minting of new tokens depends on the signature."
---

## Summary

The mint signer is a hard-coded constant that no function can replace, and it is an EOA today. If that key's account gets real code, signed minting stops. Nothing is locked: ETH already held can still be paid out to shareholders through release() with no signature, and minted NFTs move freely.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mint (0x08dc9f42) compares the recovered signer to constant 0x87a7219276164f5740302c24f5d709830f4ed91f and reverts with "Mint not signed!"
- Verified facts: 0x87a7...d91f has 0 code bytes and is not delegated (EOA)
- The only setters are transferOwnership and renounceOwnership, which write the owner slot (0x08), not the signer
- No code-size check or ERC-1271 path appears in the decompiled code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 27 transactions called it in the 90 days before that block; last on 2026-10-11.

## Remediation

Deploy a new mint contract whose signer the owner can change, or that accepts ERC-1271 signatures. Shareholders can keep withdrawing existing proceeds through release().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
