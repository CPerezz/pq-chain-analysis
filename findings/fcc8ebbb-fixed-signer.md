---
id: fcc8ebbb-fixed-signer
title: "0xfcc8ebbb (tagged deployed by Proof Of Stake Pages: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfcc8ebbbb9783a18ed4cecebfc8a2bc1dd57dec2"
  family: "36275c0e49dc489f21fbb0574cbd9ec2"
  copies: 2
  label: "deployed by Proof Of Stake Pages: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "project/owner redeploys"
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
  note: "The study note's 'presale deposit/claim' wording is inaccurate. Only the signed NFT mint uses the signature; pledging does not."
---

## Summary

The signer is the immutable owocki address, which is an EOA today, and no function can replace it. If that account gets real code, signed mints stop. No funds are locked because the contract keeps no ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mintIfSigned: address signer = ecrecover(hash,v,r,s); require(signer == owocki)
- owocki is declared as an immutable set to 0x00De4B13153673BCAE2616b67bf822500d325Fc3; bytecode facts show it is an EOA with no code
- no function writes owocki; the only setter is transferOwnership, which changes the owner
- pledge() sends msg.value to gitcoin via call, so the contract holds no balance

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract whose signer can be changed or that accepts ERC-1271 signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
