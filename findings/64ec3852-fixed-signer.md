---
id: 64ec3852-fixed-signer
title: "0x64ec3852: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x64ec3852be38ee1252d828f55c9c898e1c132172"
  family: "4b119fbd5466cbb9f63b9037ba00f9f4"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 6
  last_active: 2026-09-28
fix:
  layer: new-deployment
  who_acts: "The operator would have to deploy a new contract with a new signer."
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
  note: "The decompiler did not resolve the main signature-checking function (0x6b291987). I rated MEDIUM because the code shows no custody of user funds, only transferFrom-based flows."
---

## Summary

The quote signer is a constant EOA (0xa26c…) with no setter, no code check and no ERC-1271 path. The contract cannot be upgraded. If that key's account ever gets real code, signed quotes stop recovering and the sale/redemption function stops. Nothing appears to be locked, because the transfers go straight through transferFrom.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant quoteSigner = 927274846205769475342813267927152529368574289628 = 0xa26c71326fac07469c2af7cfea49641660ab66dc, which has no code today (EOA)
- constant treasury = 0x5b7a910c… (EOA); token constant unresolved_fc0c546a = 0x6cfb2531… (contract, 7102 bytes)
- QUOTE_TYPEHASH, MAX_QUOTE_SECONDS = 900 and usedRedemptionIds show a signed-quote flow
- transferOwnership/acceptOwnership/renounceOwnership only write the owner slots; no function writes the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-09-28.

## Remediation

Deploy a new version whose signer can be rotated, or that accepts ERC-1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
