---
id: 51ad9df0-fixed-signer
title: "0x51ad9df0 (tagged deployed by Impostors Genesis: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x51ad9df02902fe652ea039fea7f4b23bc2d1e9b5"
  family: "016256263cf41d9bf6fffadcfc8055b0"
  label: "deployed by Impostors Genesis: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner (0x7777...b468) sweeps the funds and deploys a new claim contract with a new signer"
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
  note: "I did not check whether the signer has code today. The row facts give no code size for the signer address, so EOA status is assumed. The study note calls this a presale, but the source is a staker reward claim. claim() also unlocks NFT transfers, and I did not check whether that unlock can be done another way."
---

## Summary

The claim signer is an immutable that nothing can replace, and there is no code check or ERC-1271 path. If the signer's account gets real code, claims stop working. The tokens are operator stock that the owner can take out with sweep, so a claim function stops but nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` is set only in the constructor
- validClaim compares the raw ecrecover result to signer
- No function writes signer. The only setter is transferOwnership.
- sweep() is onlyOwner and moves any token or ETH out

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Sweep the remaining tokens and deploy a new claim contract whose signer can be changed or that accepts ERC-1271 signatures. Staked NFTs whose lock claim() would have lifted need another unlock path through the Tiny721/staker admin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
