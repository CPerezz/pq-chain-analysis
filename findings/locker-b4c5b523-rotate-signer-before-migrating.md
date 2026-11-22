---
id: locker-b4c5b523-rotate-signer-before-migrating
title: "Locker: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb4c5b5235b98114e9dc227b54e088c11680b2385"
  family: "d6a325381d5fd0f84e0e98044fae4620"
  name: "Locker"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 1361
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner Safe 0x0646…fb6e"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Live Safe owner can replace the signer."
---

## Summary

Flayer Locker: its ERC-1271 isValidSignature (for airdrop claims) checks SignatureCheckerLib against a stored erc1272Signer. An EOA signer that gets code fails ECDSA; solady then tries the signer's ERC-1271.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Locker AirdropRecipient isValidSignature: SignatureCheckerLib on the stored erc1272Signer. Read (function text).
- source AirdropRecipient.sol:85 setERC1271Signer(address) onlyOwner (solady Ownable)
- owner at block 26438999 = 0x0646441c…fb6e, Safe 3-of-5 (probed)
- isValidSignatureNow falls back to ERC-1271 on erc1272Signer, so a migrated signer with 1271 also works

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,361 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owner Safe calls setERC1271Signer(new) before the signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
