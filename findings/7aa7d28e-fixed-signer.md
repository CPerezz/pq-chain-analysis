---
id: 7aa7d28e-fixed-signer
title: "0x7aa7d28e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7aa7d28eb17d3555ce8d0974f9006fe670f53e1e"
  family: "c72d6ad3cc41c38046ed2cfc11cca8cd"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/operator would need to deploy a new mint contract"
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
  note: "The study note describes this as a presale with deposit and claim. The code has neither: it is a signed NFT mint and nothing is held in escrow for users."
---

## Summary

The signer is a hardcoded constant and the contract has no way to replace it. Today that address is an EIP-7702-delegated EOA, not a contract. If the key's account ever gets real code, safeMint stops working. Already minted NFTs and the ETH balance are not affected: owners keep and transfer their NFTs, and the owner can still call withdraw.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- safeMint: address signer = ecrecover(hash, v, r, s); require(signer == 0x005199627E4aea0Ba8c85c2D182fE8852bcFEdEF)
- Bytecode facts: 0x005199627e4aea0ba8c85c2d182fe8852bcfedef has code 0xef0100afab751f0257cff58785c4fb3d819ec4a8da9410, which is a 7702 delegation, not real contract code
- No function writes the signer. The only setter listed is transferOwnership, which changes the owner
- withdraw() onlyOwner sends address(this).balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new mint contract whose signer can be rotated, or that accepts ERC-1271 signatures for the signer. Alternatively, keep the signer key as a plain EOA or a 7702 delegation and never give it real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
