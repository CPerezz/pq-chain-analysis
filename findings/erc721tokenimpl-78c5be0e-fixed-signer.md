---
id: erc721tokenimpl-78c5be0e-fixed-signer
title: "ERC721TokenImpl: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x78c5be0e413d774f9060a8581e6e7463b708a1ec"
  family: "ebdf1bf8001c027d818df18a5211415c"
  copies: 12
  name: "ERC721TokenImpl"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no funds held in the contract"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Mint gate only, no funds accumulate in this contract -> MEDIUM."
---

## Summary

ERC721Soulbound clone: mint() requires ECDSAUpgradeable.recover==trustedAddress, set only in initialize() with no setter. MINT_FEE is forwarded straight to the immutable MINT_FEE_RECIPIENT inside the same call (_payMintFee), so no mint proceeds accumulate in this contract; if trustedAddress gets code, only minting stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC721Soulbound mint: needs the trustedAddress set at initialisation, with no setter; a mint gate only (MEDIUM). Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- ERC721TokenImpl.sol:62,84-109,115,137: trustedAddress set only in initialize(), ECDSAUpgradeable.recover(digest,v,r,s)!=trustedAddress reverts (dossier source)
- ERC721TokenImpl.sol:188-198: _payMintFee forwards MINT_FEE to immutable MINT_FEE_RECIPIENT.call{value: MINT_FEE} in the same transaction
- no setter for trustedAddress anywhere in the contract

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner deploys/clones a new token implementation with a fresh trustedAddress.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
