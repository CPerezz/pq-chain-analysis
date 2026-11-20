---
id: 1e96524f-fixed-signer
title: "0x1e96524f: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x1e96524f0ffc6b00806b259e0015d9ba2350b9a1"
  family: "308ea7885e425ace7ba168981741279b"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "Holder of the hotwallet key 0xf2ec…4f93: give the account no code other than a 7702 delegation, and settle or cancel open bids before any change"
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
  note: "In claimBid the fee is also sent to hotwallet, so if hotwallet gets code that rejects ETH, the fee transfer would revert too."
---

## Summary

The signer is a hardcoded constant that today is an EOA with no code. If it gets real code, ecrecover stops returning it, so cancelBid and claimBid always revert. Bidders' escrowed ETH is then locked, and the contract has no rescue path and no upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Auction.sol: address constant hotwallet = 0xf2eC2fE12EDfeb03e6241bFC8A8E918B63da4F93
- isSigned(): ecrecover(_hash,_v,_r,_s) == hotwallet, with no ERC-1271 or code check
- cancelBid and claimBid both require(isSigned(...)) before any ETH transfer
- The contract has no withdraw or rescue function. Owner-only functions are setFee and the ownership functions

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The contract cannot be upgraded. The hotwallet key holder should keep the account as an EOA (or use only a 7702 delegation) until all Reserved bids are cancelled or claimed. Any future version should use a signer that can be replaced, support ERC-1271, and include a refund path that needs no signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
