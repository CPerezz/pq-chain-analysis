---
id: raremintserc721-a74c0b5a-rotate-signer-before-migrating
title: "RaremintsERC721: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa74c0b5adea01df5a43a6c6b5e012dc8ed5d2687"
  family: "1ebc9edeaedee4a781bf5692c1b3bf0f"
  copies: 143
  name: "RaremintsERC721"
  label: "deployed by TIgers: Deployer"
  upgradeable: "yes"
  rating: NONE
  value_usd: 18407
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 227
  last_active: 2026-11-18
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
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Refuted, because the signer path accepts ERC-1271."
---

## Summary

RaremintsERC721 checks mint signatures from owner() with OZ SignatureChecker.isValidSignatureNow.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the stored owner must sign: ECDSA, or its ERC-1271 when the owner is a contract. Read from source.
- RaremintsERC721.sol:70 SignatureChecker.isValidSignatureNow(owner(), digest, signature), which has an ERC-1271 fallback
- owner 0xd12c…49e is an EOA, nonce 422, and can also transferOwnership

## Impact and exposure

- Value held at block 26,438,999: $18,407 (ETH and 49 priced tokens, over 143 addresses).
- Activity: 227 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed. An owner with code passes through ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
