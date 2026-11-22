---
id: theeveryones-5a91f86c-fixed-signer
title: "TheEveryones: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5a91f86c4eb5f113575770f99ba8241371961c85"
  family: "374fcbd77213f3e13bc734412a60484d"
  name: "TheEveryones"
  label: "The Everyones: TheEveryones Token"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 15
  last_active: 2026-10-19
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
  note: "A signed NFT mint that dies with nothing locked is MEDIUM. It is near LOW because the public sale already offers the mint at the same price, but the whitelist allowance itself is lost."
---

## Summary

TheEveryones: whitelistMintNFT accepts only signatures by the constant WHITELIST_SIGNER. If that key takes real code, whitelist mints die. The public mint (open since 2021-12) and owner withdraw need no signature, and the contract holds 0 ETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- TheEveryones.sol:47: WHITELIST_SIGNER is a `constant` (0x9Ae97e57…4741); isWhitelisted compares ecrecover to it; no setter (source).
- Signer 0x9Ae97e57…4741 has no code at block 26438999; owner 0xb2C7c59f… is an EOA (cast code).
- Contract balance 0 ETH; withdraw() is onlyOwner and needs no signature; public mintNFT() and owner giftNFT() need no signature (source).
- disableWhitelistTimestamp=1639591200 (past), so the public mintNFT is open now.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 15 transactions called it in the 90 days before that block; last on 2026-10-19.

## Remediation

Nothing is required. Whitelisters can use the public mint.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
