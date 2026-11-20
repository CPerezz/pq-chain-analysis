---
id: 61087405-fixed-signer
title: "0x61087405: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x610874058164b6b96df2a34e34bc48b5dc7248d1"
  family: "f294158b241fb092f942f57bd1e2801a"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner. They must deploy a new claim contract. NFTs already in this one cannot be recovered."
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
  note: "Only the operator's own stock is at stake: the contract holds items or tokens the operator put there for claimants, and no user deposited anything. Claims die for good with no rescue or update path: MEDIUM (D-024: operator's own money)."
---

## Summary

The signer is immutable and is an EOA today. If its account gets real code, claim stops working for good. The contract has no owner rescue, so the NFTs it holds would be locked permanently.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer`, assigned only in the constructor
- validateClaim: `return ecrecover(digest,_v,_r,_s) == signer`
- signer() = 0x101079183d98c11d9c451da1549b9e973fffcd07, EOA (no code)
- The only transfer out is in claim(): claimedItem.safeTransferFrom(address(this), _msgSender(), nextId)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new version that has an owner rescue function for the held NFTs and a signer that can be rotated or verified with ERC-1271. The signer key should stay a plain EOA (or use only a 7702 delegation).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
