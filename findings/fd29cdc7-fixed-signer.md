---
id: fd29cdc7-fixed-signer
title: "0xfd29cdc7 (tagged deployed by Mirage Gallery: Vault): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfd29cdc7868cacece537571bd0c879df55f2bc51"
  family: "a2e10960155c0e9bfcbd094f048a7782"
  label: "deployed by Mirage Gallery: Vault"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 8
  last_active: 2026-11-05
fix:
  layer: new-deployment
  who_acts: "Owner: move the sale to the public phase (updateMintStatus) or deploy a new contract"
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
  note: "I identified the signer address from the bytecode values: it is the only one that is not ASCII text. The source does not show a getter for _adminSigner, so this is an inference, not read from the code."
---

## Summary

The coupon mints check a raw ecrecover result against an immutable _adminSigner. Nothing can replace the signer and the code has no code check or ERC-1271 path. If the signer's account got real code, only the allowlist mints would stop. No funds are locked: the owner can still withdraw, and the public mint needs no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _adminSigner;` is assigned only in the constructor
- _isVerifiedCoupon: `ecrecover(digest, coupon.v, coupon.r, coupon.s)` then `return signer == _adminSigner`
- intelligentMint, holderMint and partnerMint each `require(_isVerifiedCoupon(...))`
- No function writes _adminSigner; transferOwnership only changes the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-05.

## Remediation

Owner moves the sale to publicSale, or deploys a new contract whose signer can be changed or that accepts ERC-1271

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
