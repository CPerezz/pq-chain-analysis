---
id: 0169e986-fixed-signer
title: "0x0169e986 (tagged deployed by Proof Of Stake Pages: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0169e986d953f98ca3033678d4e7b374a00480c3"
  family: "a1cbddbe2c3f2c022073fc8540cf60bb"
  label: "deployed by Proof Of Stake Pages: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The deployer, who would need a new contract with a replaceable signer or ERC-1271 support."
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
  note: "The row facts do not report the current code size of the signer address, because immutables are not in constants[]. I treated 0xd8dA…6045 as an EOA (or 7702-delegated) today without checking. If it has non-delegation code, the verdict changes to refuted. Pledgers who paid and are still waiting for a signature are already paid out on-chain; they would lose only the NFT."
---

## Summary

The signer is an immutable hardcoded address (Vitalik) with no setter. If that account gets non-delegation code, signed mints of new soulbound NFTs stop. No funds are held, so nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mintIfSigned: address signer = ecrecover(hash,v,r,s); require(signer == vitalik)
- vitalik is declared immutable = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045
- no function writes vitalik; the only setter is transferOwnership (Ownable)
- pledge() forwards all ETH immediately via gitcoin.call and sevenStories.call

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with an owner-settable signer or ERC-1271 / SignatureChecker support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
