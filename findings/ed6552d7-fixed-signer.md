---
id: ed6552d7-fixed-signer
title: "0xed6552d7 (tagged Cool Monkes: Staking): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xed6552d7e16922982bf80cf43090d71bb4ec2179"
  family: "573972d8eac7ddc40a4c78eaddf58b0d"
  label: "Cool Monkes: Staking"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "The owner (0xbbaef1cf314755f3182fb8388061da3cf8724fee) must call emergencyRescue to return users' NFTs"
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
  note: "Rated MEDIUM, not HIGH, because staked NFTs can still be recovered: the owner can return them through emergencyRescue. Recovery depends on the owner key staying active and the owner acting in good faith."
---

## Summary

The signer is a constant EOA with no code today and nothing can replace it. If that account gets code, stake and unstake stop working. Staked NFTs are not locked, because the owner can return them with emergencyRescue without a signature. Users cannot do this themselves, so they depend on the owner.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Line `address public constant enforcerAddress = 0xD8A7...99CE`: the signer is a constant
- verify() compares the raw ecrecover result to enforcerAddress, with no code check and no ERC-1271 path
- unstake() requires verify(enforcerAddress, ...)
- emergencyRescue is onlyOwner and transfers staked NFTs to any account without a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before the signer gets code, the owner uses emergencyRescue to return staked NFTs to their recorded owners (monkeStaked/boostStaked), then deploys a new staking contract that uses a signer it can replace.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
