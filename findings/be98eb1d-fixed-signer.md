---
id: be98eb1d-fixed-signer
title: "0xbe98eb1d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbe98eb1dfc252d231305ca44ded8e5560e0703d0"
  family: "b93b2e24bc4e42d1f5e3f89ebb426999"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 3
  last_active: 2026-11-14
fix:
  layer: new-deployment
  who_acts: "project/deployer"
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
  note: "The study note says 'presale deposit/claim', but the code is an NFT allowlist mint. If the signature stops working, only new mints are lost, so the rating is MEDIUM."
---

## Summary

Allowlist mints check the signature against a hardcoded signer, 0x44b4…06a5, which has no code today. If that account gets code, only the allowlist mints stop. No funds held for users are locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- allowListOneFreeMint/allowListTenFreeMint: require(var_u == 0x44b40b38b27d7e2282701b8b114723a1dbcf06a5, CustomError_815e1d64())
- constant allowListSigner is in the bytecode, and the decompiled code has no function that writes a signer
- Verified fact: 0x44b40b38… has no code (EOA)
- publicMint(uint256) needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

Keep the signer key as a plain EOA, or deploy a new contract with a signer that can be replaced or that accepts ERC-1271. Public mint stays available in the meantime.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
