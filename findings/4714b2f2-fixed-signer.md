---
id: 4714b2f2-fixed-signer
title: "0x4714b2f2: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4714b2f2379ddc19d19be84e982da707f4ecfc61"
  family: "499497174fb6b050e9c37ce8d160f265"
  upgradeable: "no"
  rating: HIGH
  value_usd: 8
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "Holder of the signer key 0x51d8...d08b (keep it an EOA or use only EIP-7702 delegation)"
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
  rating: HIGH
  note: "The owner getter currently returns the same address as the signer, but the checks compare against the hardcoded constant, so changing the owner doesn't change the signer."
---

## Summary

The signer is a constant address in the bytecode and has no code today. Bidder ETH deposited through makeBid can leave only through cancelBid or claimBid, and both need that signer's signature. There's no rescue function and no upgrade path, so deposits would lock if the signer's account got real code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cancelBid/claimBid/makeBid: require(0x51d87492c2fef5a0edf6e23208d9a02c61b0d08b == address(var_p), "bad-signature")
- makeBid: storage_map_a[arg1].field_1 = msg.value (contract keeps the user's ETH)
- cancelBid: payable(msg.sender).transfer(field_1) only after the signature check
- transferOwnership writes store_d (slot 0, owner), not the constant signer

## Impact and exposure

- Value held at block 26,438,999: $8 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The signer key holder must never put real (non-7702) code on 0x51d8...d08b, and should process refunds for all open bids while signatures still recover. Any future version should allow the signer to be changed or accept ERC-1271 signatures, and should include a refund path that doesn't need a signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
