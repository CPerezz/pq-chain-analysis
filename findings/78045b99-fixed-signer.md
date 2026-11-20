---
id: 78045b99-fixed-signer
title: "0x78045b99 (tagged deployed by Genetic Chain: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x78045b99d962e1722f792b8ea4f396aea150ac37"
  family: "e3177f050a215aab3cbc9a064b551f96"
  label: "deployed by Genetic Chain: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project owner, who would deploy a new contract or mint through galleryMintTo"
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
  note: "The study note calls this a presale with deposit and claim. The code is actually a signed NFT mint, and only secureMint needs the signature."
---

## Summary

The signer is a constant that nothing can change, and that address has no code today. If it gets code, secureMint stops working. Only the minting of new NFTs stops; no funds are locked, because the owner can withdraw the ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- GeneticChain721: address constant private _signer = 0x1A6d...Da5c
- validateSigner uses ECDSA recover == _signer; there is no isContract check and no ERC-1271
- Row facts: the signer constant has code_bytes 0 and is not delegated
- withdraw(address,uint256) onlyOwner pays out the contract balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new mint contract whose signer the owner can change, or have the owner mint for allowlisted users through galleryMintTo (limited to galleryMax).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
