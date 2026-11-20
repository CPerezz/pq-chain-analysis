---
id: remarkablewomen-3e69baab-fixed-signer
title: "RemarkableWomen: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3e69baab7a742c83499661c5db92386b2424df11"
  family: "e7167128e25d8a628d0ce1ca64569bb7"
  name: "RemarkableWomen"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 36
  last_active: 2026-11-12
fix:
  layer: new-deployment
  who_acts: "owner"
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
  note: "No update path for the gate; a signed NFT mint that dies, with nothing locked, is MEDIUM. Public mint and gifting stand in only by dropping the whitelist gate."
---

## Summary

RemarkableWomen: whitelistMintNFT accepts only signatures by the constant WHITELIST_SIGNER. If that key's account takes real code, whitelist (and ambassador) mints die for good. No money is locked: the contract holds 0 ETH, and the owner withdraws by direct call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- RemarkableWomen.sol:50: WHITELIST_SIGNER is a `constant` (0x333D7008…9C1c); isWhitelisted compares ecrecover to it; no setter (source).
- Signer 0x333D7008…9C1c has no code at block 26438999; owner 0xb2C7c59f… is an EOA (cast code).
- Contract balance 0 ETH; withdraw() is onlyOwner and needs no signature; public mintNFT() and owner giftNFT() need no signature (source).
- salePaused()=true today; the owner can reopen it.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Keep the whitelist key free of code; otherwise the owner opens the public sale or gifts NFTs to former whitelisters.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
