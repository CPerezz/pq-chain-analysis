---
id: 8feeaf7a-fixed-signer
title: "0x8feeaf7a: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8feeaf7abe455db14bd5c85543787f39437e1e7a"
  family: "133be40fdbf4d1e3b994fad5616d2013"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner/operator deploys a new airdrop contract with a new signer"
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
  note: "The row's study_note calls this a presale with deposits, but the code is an airdrop with no user deposits."
---

## Summary

The signer is immutable and has no setter. Its address 0x14185d…d959 has no code today. If that account gets real code, claims stop working. No funds get locked because the tokens stay in the owner's wallet and are only pulled by allowance.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable contractSigner` is assigned only in the constructor
- getAirdrop: require(ecrecover(msgh, v, r, s) == contractSigner)
- deliverTokens: safeTransferFrom(owner(), to, ...): the stock is in the owner's wallet
- Constant 0x14185d5cd8589b194e881b9bdd081c185d5cd959 has code_bytes 0 and is not delegated

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new airdrop contract with a new signer and move the token allowance to it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
