---
id: d3d9df7d-fixed-signer
title: "0xd3d9df7d (tagged deployed by Genetic Chain: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd3d9df7d49800db66f98a5a3c5653c52cd33ad05"
  family: "72aea0e45ec9535eb613555d4747931a"
  copies: 2
  label: "deployed by Genetic Chain: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/project would redeploy a new collection with a new signer"
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
  note: "Only new mints stop. No funds or minted NFTs are locked."
---

## Summary

The signer is a constant EOA (no code today). If that key's account gets real code, secureMint stops working and no more NFTs can be minted. Nothing already held gets locked: the contract holds no funds, and minted NFTs still transfer normally.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- _signer declared constant 0xd001479103D30338d93357Ef33BD69e56BB5B5fa; code_bytes 0, not delegated
- secureMint requires validateSigner(...) using ECDSA recover == _signer, with no ERC-1271 or code check
- No setter for _signer exists; setters list only transferOwnership
- upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be changed or that accepts ERC-1271 signatures, or keep the signer key a plain EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
