---
id: 32eb69ae-fixed-signer
title: "0x32eb69ae: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x32eb69ae538e1eec3a6cd0123352af23ae656e32"
  family: "05ce67fee499c1655e3f97edc5b963bd"
  copies: 4
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project operator would have to redeploy, because the contract has no upgrade path."
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
  note: "The body of 0x34b74c81 is truncated in the decompilation, so the claim/mint semantics come from the storage layout and selector names rather than from its code. The rating is MEDIUM because only new NFT claims stop and no existing user funds are visible."
---

## Summary

The signer is a hard-coded constant, 0xc90a…f5f, and that address is an EOA today. Nothing can replace it, and the code has no code-check or ERC-1271 fallback. If the signer key's account gets code, signed voucher claims of new NFTs stop working. No user funds already held would be locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Decompiled code: `uint256 public constant signer`. The `signer()` getter returns 0xc90a5663326637d6c852258400ca9643ca4aef5f, and the verified facts list that address as an EOA (no code).
- Row facts list only `transferOwnership(address)` as a setter. It writes the owner (store_g, slot 7), not the signer.
- Row facts: upgradeable = no, with no proxy slot and no upgrade function.
- `voucherUsed(bytes32)` and `xboxIdClaimedBy` show voucher-based NFT claims.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be replaced, or that accepts ERC-1271 signatures, and move the remaining claims to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
