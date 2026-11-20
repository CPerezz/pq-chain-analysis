---
id: 6fd82221-fixed-signer
title: "0x6fd82221: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6fd82221d5dfb6a0fc9106e1ba58613ab8ef6425"
  family: "0f40d522ef16a0af98d45b65306c9c3c"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 2
  last_active: 2026-09-25
fix:
  layer: onchain-config
  who_acts: "Owner"
evidence:
  level: source-read
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
  note: "The study note says 'presale deposit/claim', but this contract is actually a free NFT whitelist mint with no deposits."
---

## Summary

The whitelist signer is an immutable value with no setter, and it is an EOA today. If that key's account gets code, signed whitelist mints stop working. No funds are locked: the owner can advance to the public mint phase, which needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable signer;` is assigned only in the constructor
- whitelistMint requires recoverSigner(hash, signature) == signer and uses ECDSA.recover with no ERC-1271 check
- The only address in the bytecode, 0xc46d1db3e8ec0fa9be7a1f87d309f11745b4001a, is an EOA (no code)
- mint() in phase 2 needs no signature, and enterNextPhase is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

The owner calls enterNextPhase to move to public mint (phase 2), which skips the signature. Or deploy a new contract with a signer that can be changed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
