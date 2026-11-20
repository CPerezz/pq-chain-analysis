---
id: blackisbeautiful-b8ec99b0-fixed-signer
title: "BlackIsBeautiful: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb8ec99b004b8b7701df6db4f2dc7899505af9d09"
  family: "d0d0dc3f9a3bd0f233c7d384facb29e4"
  copies: 3
  name: "BlackIsBeautiful"
  upgradeable: "no"
  rating: LOW
  txs_90d: 42
  last_active: 2026-10-27
fix:
  layer: onchain-config
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
  rating: LOW
  note: "A setting fixes it, and another path gives the same act."
---

## Summary

BlackIsBeautiful NFT: the constant ALLOWLIST_SIGNER 0x8430…2aa5 (an EOA) signs the allowlist mint (only in signatureMode) and the ambassador mint. The owner can switch the allowlist to Merkle proofs (setSignatureMode false) and give ambassadors their NFTs with airdropToAmbassador. Proceeds leave with the owner's withdraw().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: TheEveryones isWhitelisted: WHITELIST_SIGNER, a constant / PayToUnlock recoverSigner: returns the recovered address. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: ALLOWLIST_SIGNER is constant; signatureMode can be set by the owner with setSignatureMode; airdropToAmbassador is onlyOwner
- owner 0xb2c7… is an EOA (live); withdraw() is onlyOwner
- Signer 0x8430… has no code

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 42 transactions called it in the 90 days before that block; last on 2026-10-27.

## Remediation

The owner sets signatureMode = false and airdrops to ambassadors.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
