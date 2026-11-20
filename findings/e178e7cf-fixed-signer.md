---
id: e178e7cf-fixed-signer
title: "0xe178e7cf: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe178e7cf58ca08432e064c472f4b5dc7bf342c2c"
  family: "9c9293db1f1229dca7c1816d966fa195"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-10-12
fix:
  layer: offchain
  who_acts: "Owner: can use ownerMint to give out the free-mint allocation without a signature"
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
  note: "The study note calls this a presale with signed deposit and claim, but this code is an NFT mint where only the free mint needs a signature. Rated MEDIUM because only one function stops and nothing is locked; the owner's ownerMint path takes over that function."
---

## Summary

The signer is a constant EOA (code size 0, no delegation) and no function can replace it. Only freeMint depends on it, and that function only mints new NFTs; no funds are held behind the signature. The owner can hand out the same allocation with ownerMint.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- weart.sol: address constant signer = 0x6a6b0c3D0c9123777eA2bF2e6344071a18da3c42
- _verifySignature compares the ECDSA.recover result to signer with ==; there is no code check and no ERC-1271 path
- Row facts: the signer address has code_bytes 0 and delegated false; upgradeable: no
- freeMint is the only caller of _verifySignature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-12.

## Remediation

If the signer key ever gets code, the owner hands out the free mints off-chain and through ownerMint. The signer cannot be changed without a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
