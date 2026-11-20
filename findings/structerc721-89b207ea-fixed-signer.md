---
id: structerc721-89b207ea-fixed-signer
title: "StructERC721: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x89b207ea9d00484a0b3051f8e24b543c2c59f08a"
  family: "b98aabff90ef0cc27cc40e8e4587afe3"
  copies: 30
  name: "StructERC721"
  label: "Nakamotos III: NKS Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 105
  last_active: 2026-11-16
fix:
  layer: none
  who_acts: "none"
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
  note: "Only allowlist minting dies and nothing is locked, so MEDIUM. The row's HIGH is not supported."
---

## Summary

This is a fixed-implementation proxy to StructERC721. privateMint needs config.signer (set at initialize, no setter); _validatePrepaid's _RECEIPT_ISSUER is immutable, but an invalid receipt just falls back to paying the fee. The owner can switch to publicMint, and proceeds leave through PaymentSplitter release/releaseAll.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: StructERC721 _validatePrepaid: _RECEIPT_ISSUER, an immutable / StructERC721 privateMint: the stored config.signer must sign. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- Proxy has only implementation() (pure) = 0x1ad7…7e7b and an empty EIP-1967 slot, so it cannot be upgraded.
- config.signer = 0xf661…dfc4 (no code); the mint status is currently PUBLIC (2), so privateMint is already closed.
- _validatePrepaid returns false rather than reverting, and the caller then pays _FREE_MINT_TOKEN_PRICE×maxSupply; releaseAll is onlyOwner, and release is public.

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens, over 30 addresses).
- Activity: 105 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

None needed; public mint and payouts work without signatures.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
