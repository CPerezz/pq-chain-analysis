---
id: 069b525f-fixed-signer
title: "0x069b525f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x069b525f5e5f1a4de76be06d0febf5e24b09d609"
  family: "41f29e92ad7b9c674f96a7abbbb3beb8"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Project owner: open the public sale or redeploy to restore the claims"
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
  note: "The value of _adminSigner is not in the row facts, so I could not check its code today. I assumed it is an EOA. If it already has non-7702 code, the verdict should be refuted."
---

## Summary

Coupons are checked against the immutable _adminSigner, and nothing can change it. If that key's account got real code, presale, author and genesis-reserved claims would stop working. Nothing would be locked: the public mint and the owner's ETH withdrawal need no signature, and a failed coupon in an ERC1155 genesis claim makes the whole transfer revert, so the user keeps the token.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _adminSigner;` is assigned only in the constructor
- _isVerifiedCoupon: `ecrecover(...)`, then `signer == _adminSigner`, with no code check and no ERC-1271
- The only setter is transferOwnership, which changes the owner and not the signer
- onERC1155Received: `require(_isVerifiedCoupon(...))` reverts the whole 1155 transfer, so nothing is stuck

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a signer that can be replaced, or accept ERC-1271 signatures. In the meantime, use the public mint phase.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
