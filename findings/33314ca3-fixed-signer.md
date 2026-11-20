---
id: 33314ca3-fixed-signer
title: "0x33314ca3: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x33314ca32fe09b9077fa621be723bdafecbde4a9"
  family: "e58dae0b3ceb78ed886739e160276a4a"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Operator (the hotwallet key holder) must deploy a new contract. ETH already held in Reserved bids cannot be recovered."
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
  rating: HIGH
  note: "The owner (0xbf89…) is the same address as hotwallet. The 1% fee in claimBid is also sent to hotwallet, so if hotwallet gets code that rejects ETH, claimBid would revert anyway."
---

## Summary

The signer is a fixed constant, hotwallet 0xbF89…, which has no code today (an EOA). If that account gets real code, ecrecover stops matching it. Every Reserved bid's ETH then stays locked, because the only payout functions, cancelBid and claimBid, need the signature, and the contract has no upgrade path and no rescue function.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Auction.sol: `address constant hotwallet = address(0xbF89E87B4BF528b484887E0fEb259F1Efe565b65)`
- isSigned: `address _signer = ecrecover(_hash,_v,_r,_s); return _signer == hotwallet;` with no code check and no ERC-1271 fallback
- cancelBid: `require(isSigned(cancel,...))` comes before `msg.sender.call{value: bid.amount}`
- claimBid: `require(isSigned(claim,...))` comes before the payouts

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the hotwallet key as an EOA, or as a 7702-delegated account at most, so its signatures keep recovering. Any future contract should have a replaceable signer, a code check or ERC-1271 fallback for it, and a timeout refund path that needs no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
