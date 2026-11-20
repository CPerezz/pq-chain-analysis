---
id: orionreferral-6956f9df-rotate-signer-before-migrating
title: "OrionReferral: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6956f9df52a03e81c6898fd905ba0834a87e3bb2"
  family: "4c49506616655288dbaf41567bf0d615"
  copies: 3
  name: "OrionReferral"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

OrionReferral (proxy, impl 0xc743b717…): referral claims need a signature from verifier; under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setVerifier). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setVerifier(address) in impl is onlyOwner (Sourcify verified impl source (line 31))
- owner() at 26438999 = 0x857851EE6E398651Cb7C72462cc7Ce2A94d8f1C6, no code, nonce 182 (node)
- EIP-1967 impl 0xc743b717…, admin 0x4bad9324… at 26438999 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
