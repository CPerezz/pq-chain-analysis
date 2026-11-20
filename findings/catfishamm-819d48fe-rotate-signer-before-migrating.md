---
id: catfishamm-819d48fe-rotate-signer-before-migrating
title: "CatfishAMM: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x819d48fe265c23c9b3cbfb42f5c48f24d956146b"
  family: "039b8c557da78839674277f65ca1d691"
  copies: 4
  name: "CatfishAMM"
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
  note: "Setter exists (row named the owner as signer; actual key is _ammSinger with an onlyOwner setter), owner is a live EOA."
---

## Summary

CatfishAMM UUPS proxy (impl 0xa8defc77…): AMM actions need a signature from _ammSinger (not the owner, as the row note says); under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership, transferOwnership). Rule: stored-key (the owner).
- setAmmHolderAndSinger(address,address) is onlyOwner (Blockscout verified impl source (lines 4572-4576, 4618))
- owner() at 26438999 = 0x51244f929A2eAd334060fe4C58921285740E10bf, no code, nonce 32 (node)
- EIP-1967 impl slot = 0xa8defc77… at 26438999 (node)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
