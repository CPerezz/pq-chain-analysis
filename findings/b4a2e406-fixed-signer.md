---
id: b4a2e406-fixed-signer
title: "0xb4a2e406: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb4a2e4067dcdc992d6931c9eca85bb689682cab4"
  family: "15c1e308181710ef8374028d03a3cfd6"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner/team would need to redeploy or hand out giveaways another way"
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
  note: "The study note calls this a presale with signed deposit and claim. The code shows that is wrong: it is an NFT contract, and only the giveaway mint needs a signature."
---

## Summary

The signer is a hardcoded constant that has no code today. If it gets code, giveaway claims stop working. Nothing is locked: ETH leaves through the owner's withdraw() and the winners' withdrawPrize().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- signerPubKey is declared constant as 0x64C28c...32b9, and the row facts give its code_bytes as 0 with delegated false
- _isVerifiedCoupon returns signer == signerPubKey and has no ERC-1271 or code check
- The validateCoupon modifier is used only by claimGiveaway
- withdraw() is onlyOwner and sends address(this).balance; withdrawPrize() needs no signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be rotated or that accepts ERC-1271, or give out giveaway NFTs through a mint path that does not need a signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
