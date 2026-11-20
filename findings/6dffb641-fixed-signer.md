---
id: 6dffb641-fixed-signer
title: "0x6dffb641 (tagged deployed by Kahiru: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6dffb6415c96ec393bf018fb824934d7b5b637a0"
  family: "c1570c0a6e8d23b8483ab335af3c8114"
  label: "deployed by Kahiru: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new staking contract, and the StoneParticles owner calls addController for it."
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
  note: "The study note calls this a presale where deposit and claim need a signature. The code shows something else: only stake is signature-gated, and claim and unstake are open to the staker."
---

## Summary

The signer is a hardcoded constant and is an EOA today, so the fixed-signer claim holds. Only stake() checks a signature. Unstake and claim do not, so NFTs already staked can still be withdrawn and rewards still claimed. If the signer gets code, only new staking stops and nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- recoverSigner compares the recovered address to the literal 0x0aC6119362e892aeA0025BF00182CaD3673A9c79
- Row facts: constant 0x0ac6…9c79 has code_bytes 0 and delegated false, so it is an EOA today
- stake() has require(recoverSigner(hash, signature))
- unstake() calls _claim(msg.sender, tokenIds, true), which calls _unstakeMany and transfers the NFT back. No signature is needed.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new staking contract whose signer can be replaced or that accepts ERC-1271 signatures, then add it as a StoneParticles controller. Users of this contract can unstake without any change.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
