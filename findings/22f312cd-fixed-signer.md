---
id: 22f312cd-fixed-signer
title: "0x22f312cd: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x22f312cd8447d93949a296fb619cbc4b1fea3ced"
  family: "f5f756edd4e0791a4af6628494a468dc"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0xc2a663297a52dbd6e5c5812390f20b550c720684) would need to deploy a new contract with a new signer."
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
  note: "The decompiler output does not show the ecrecover comparison. Treating 0x8e38… as the signer relies on it being the only real address constant in the bytecode, plus the study note. The study note's \"deposit/claim presale\" description does not match the code, which is an NFT mint where payment and minting happen in one step."
---

## Summary

The signer appears to be a hard-coded address that is an ordinary wallet (no code) today, and nothing in the contract can replace it. If that wallet gets code, signed mints stop working. Already-minted NFTs and the ETH balance are not affected: holders can still transfer, and the owner can still withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Address constant 0x8e3806a9c98ba1100afce6dddc17223a2dc680f1 has code_bytes 0 (no code, not delegated)
- Only setters found: transferOwnership and renounceOwnership, both writing the owner slot (0x0a)
- withdraw(): require(owner==msg.sender); transfers address(this).balance to the owner
- Constants 0.08 ETH (unresolved_e2af4aa6) and 1024 (unresolved_ebee2e2d) point to a paid NFT mint

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be rotated, or one that accepts ERC-1271 signatures. Keep the current signer key as a plain wallet with no code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
