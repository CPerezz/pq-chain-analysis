---
id: 4e3a074a-rotate-signer-before-migrating
title: "0x4e3a074a: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4e3a074a08010430f4d0f570785a8c70265128d6"
  family: "66c209d829fcf8ad51561cf8e0aeebde"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
evidence:
  level: bytecode
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

UUPS proxy (impl 0xa98654eb…) of a red-packet contract: claims are checked against signer(); under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (updateSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- updateSigner(address) 0xa7ecd37e in impl (require owner == msg.sender) is onlyOwner (heimdall decompile of impl 0xa98654ebecf6ea349d968a1dd8422dab79c4a87a)
- owner() at 26438999 = 0x68e9Aef58197db16546397f7136Af393511481cf, no code, nonce 88 (node)
- EIP-1967 impl slot = 0xa98654eb… at 26438999 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
