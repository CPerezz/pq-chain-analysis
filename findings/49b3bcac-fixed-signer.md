---
id: 49b3bcac-fixed-signer
title: "0x49b3bcac: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49b3bcacba13557500b63cb7e0757086aa87b602"
  family: "9bdbd57b51301d6cf34eaf144369951b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project operator, who would need to deploy a new contract"
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
  note: "The study note calls this a presale, but the code is a free NFT mint. I inferred that 0xc04b…f342 is the SIGNER immutable because the other values in the bytecode decode as ASCII strings. Every candidate has no code either way, so the verdict doesn't depend on which one it is."
---

## Summary

SIGNER is immutable and has no setter, and the code has no code check or ERC-1271 path. The only 20-byte value in the bytecode that looks like a real address (0xc04b…f342) has no code (EOA). If that key's account gets code, signed mints stop. No funds are held, so the only effect is that new free NFTs can no longer be minted.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- verify(): `address signer = ecrecover(prefixedHash,_v,_r,_s); return signer == SIGNER;`
- `address public immutable SIGNER;` is assigned only in the constructor
- mint() is not payable, so no user funds are deposited
- Row facts: upgradeable 'no'; the only setter is transferOwnership (owner only)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be rotated, or one that accepts ERC-1271, and continue minting there.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
