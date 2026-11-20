---
id: ab58c868-fixed-signer
title: "0xab58c868: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xab58c8683c28901a52c347354c141bfd13e26831"
  family: "f41539de7e9de4f9bad19b362683e420"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project owner would have to deploy a new sale contract or use the public sale."
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
  note: "The signed path only mints new NFTs. The rating is MEDIUM because only that function stops: no funds are locked."
---

## Summary

The presale signer is a hardcoded constant with no code today (an EOA). If that account gets code, presale mints stop working. Nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- configuration.sol: address constant _presigner = 0x419B…e810
- verify(): return _presigner == recovered; there is no code check and no ERC-1271 path
- Row facts: constant 0x419b… has code_bytes 0 and is not delegated
- Row facts: upgradeable is 'no'; the only setter is transferOwnership

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract that has a signer setter or accepts ERC-1271 signatures, or move buyers to the public mint().

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
