---
id: c8df9479-fixed-signer
title: "0xc8df9479: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc8df9479d31994eba04c38c947478f0d674ad700"
  family: "3cd11ab3f9fc5a2e023a0570bf69df9e"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator: deploy a new claim contract and have TOKEN_HOLDER approve it."
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
  note: "The study note calls this a 'presale with deposit'. The code shows no deposits, only a signed NFT giveaway claim."
---

## Summary

SIGNER is a compile-time constant with no setter, and today it is an EOA with no code. If that key's account gets real code, claims stop. No user funds are held: the NFTs stay with the operator's TOKEN_HOLDER EOA, so only the giveaway function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- address constant SIGNER = 0xd0F071258DA42A8736Ca728E0ad129Ff09dfB6ab; row facts show code_bytes 0 and not delegated
- _verifySignature compares the ECDSA.recover result to SIGNER, with no isContract or ERC-1271 check
- _mint calls EVE.transferFrom(TOKEN_HOLDER, to, id); TOKEN_HOLDER 0xe612… has code_bytes 0
- The only setters are transferOwnership, togglePaused and setNextId; upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new claim contract whose signer can be replaced or that accepts ERC-1271. Have TOKEN_HOLDER approve it and revoke the old approval.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
