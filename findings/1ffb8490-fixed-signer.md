---
id: 1ffb8490-fixed-signer
title: "0x1ffb8490 (tagged deployed by Genetic Chain: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1ffb8490828512e8a3e6c2e62e4882e8440b558d"
  family: "96de8bf35b81d9bda3bfe8bd741b3f12"
  label: "deployed by Genetic Chain: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-25
fix:
  layer: new-deployment
  who_acts: "project owner/deployer"
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
  note: "The study note describes a presale with deposit and claim, but this code is an NFT signed mint with no deposits. The rating follows the code: only minting stops and nothing is locked."
---

## Summary

The mint signer is a compile-time constant, and that address has no code today (code_bytes 0, not delegated). If that key's account gets real code, secureMint stops working, so no new NFTs can be minted. No funds are held, and NFTs already minted can still be transferred.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- GeneticChain721.sol: address constant private _signer = 0xA1A02a3A32B31C065FFf50d8ac7770B6e0CbB343
- validateSigner: return msgHash.recover(signature) == signer; no ERC-1271 or code check
- secureMint is the only mint path and requires validateSigner(..., _signer)
- Row facts: the signer constant has code_bytes 0 and delegated false; upgradeable is 'no'

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Deploy a new collection whose signer can be updated, or one that accepts ERC-1271 signatures; keep the signer key's account free of code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
