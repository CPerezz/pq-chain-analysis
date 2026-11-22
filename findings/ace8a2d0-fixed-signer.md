---
id: ace8a2d0-fixed-signer
title: "0xace8a2d0 (tagged Cool Monkes Trainers: CTRNRS Token): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xace8a2d0f41702161d8363eddae981e844c35c6e"
  family: "656d021aca8803bf5803d08c59339d41"
  label: "Cool Monkes Trainers: CTRNRS Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4
  last_active: 2026-10-27
fix:
  layer: new-deployment
  who_acts: "Project owner would need to deploy a new claim contract with a new signer"
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
  note: "The study note says this is a presale with deposits, but the code shows only a free signed NFT claim with no deposits. Rated MEDIUM because only a function stops."
---

## Summary

The signer is a hard-coded constant EOA (it has no code today). If that key's account gets code, claimTrainers stops working. Only new mints are affected. Existing NFTs can still be transferred and nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- enforcerAddress constant 0xD8A7...99CE, code_bytes 0, not delegated
- claimTrainers requires verify(enforcerAddress, ...) == true
- recoverSigner uses raw ecrecover, with no code check and no ERC-1271 path
- No setter for enforcerAddress; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

Deploy a new claim/mint contract with a signer that can be replaced, or one that supports ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
