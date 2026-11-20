---
id: 2b8a29ae-fixed-signer
title: "0x2b8a29ae: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2b8a29ae7b7f57055b19b43354064d5c646a2678"
  family: "ca57fa6a0400c5d9c92e2d86b70e68fc"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The owner would have to redeploy with a new signer. The current contract cannot replace the immutable signer."
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
  note: "I assumed the address constant found in the bytecode, 0x2932b1b2b4bb32b91034b6b83632b6b2b73a32b9, is the immutable _adminSigner value; the facts do not label it. The study_note says this is a presale with deposit and claim, but the source shows an NFT mint that needs a coupon."
---

## Summary

The coupon signer is an immutable set at deployment, and no function can change it. If the signer key's account gets real code, the signed mint stops working. Nothing already held gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _adminSigner;` is set only in the constructor
- verifyCoupon: `ecrecover(...)` result is compared with `== _adminSigner`, with no isContract/ERC-1271 path
- mint() requires verifyCoupon(digest, coupon)
- The only setter listed is transferOwnership, which changes the owner and not the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a new signer, a signer setter, or ERC-1271 support. Otherwise the owner can distribute tokens through teamMint, which is limited to the team reserve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
