---
id: db95f079-fixed-signer
title: "0xdb95f079 (tagged deployed by MoonLanderz: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xdb95f079155aaf1088e3106eb39eade65f2dcb5e"
  family: "f72ee526eb18f26039cae37551994e43"
  label: "deployed by MoonLanderz: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner deploys new claim contract or calls giveBackOwnership() to reclaim MoonBase and mint directly"
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
  note: "This is an NFT mint, not a presale with deposits: no balance stays in the contract."
---

## Summary

AUTHORITY is a hard-coded constant with no code today (EOA). If it gets non-delegation code, signed mint/freeClaim always revert. Nothing is held, so only new mints stop. The owner can take back MoonBase ownership.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant AUTHORITY = 0x8FDb63D69bCd146D7a52C55196d8ec5692e41369, code_bytes 0, not delegated
- freeClaim and mint: ecrecover(...) != AUTHORITY -> revert GivenMintOrderVerificationFailed
- no setter for AUTHORITY; setters list only transferOwnership
- giveBackOwnership() transfers MoonBase ownership to owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls giveBackOwnership() and redeploys a claim contract with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
