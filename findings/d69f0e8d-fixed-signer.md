---
id: d69f0e8d-fixed-signer
title: "0xd69f0e8d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd69f0e8ddeabc569ae98505e200e48654b495977"
  family: "611f8b39fb3061e25d217e70a0cdb4c3"
  copies: 3
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner, who would call emergencyWithdraw and redeploy with a new signer"
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
  note: "The decompiled execute path calls permit (selector d505accf) on USDT, so it may not work at all. That does not change the signer analysis."
---

## Summary

The signer is a hard-coded constant address with no code today (an EOA), and nothing can replace it. If that key's account ever gets real code, execute stops working. The USDT is not locked, because the owner can still pull it out with emergencyWithdraw. Only the release function stops, so the rating is MEDIUM.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Constant UBS_BANK_WALLET (decimal 609513959103517017618053751437439725252789663243) is 0x6ac38d1b2f0c0c3b9e816342b1ca14d91d5ff60b
- In 0xc4935019 the recovered signer is checked against that constant: require(0x6ac38d1b... == ..., "Invalid UBS signature")
- 0x6ac38d1b... has 0 code bytes and is not 7702-delegated at block 26438999
- The only setters are owner-only: transferOwnership and the once-only setMasterWallet. Neither touches the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be replaced or that accepts ERC-1271 signatures. Until then, the owner can recover the USDT with emergencyWithdraw.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
