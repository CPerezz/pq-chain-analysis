---
id: bonetoken-c54ac94b-signed-shortcut-lost
title: "BoneToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc54ac94b8c153dc54fd21e738efe5a5320f6e54f"
  family: "94acee98f6e221028c9564b393173af3"
  copies: 24
  name: "BoneToken"
  label: "SushiSwap: SUSHI Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 39339
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 83930
  last_active: 2026-11-18
fix:
  layer: offchain
  who_acts: "the holder"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $39339, txs_90d 83930."
---

## Summary

BoneToken token with Compound-style delegateBySig; under EIP-8151 a holder whose address has code cannot delegate by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (Compound style): whoever signed delegates; zero rejected. Read from source.
- BoneToken: delegateBySig recovers the signer and delegates for it (dossier source, delegateBySig (Compound style): whoever signed delegates; zero rejected)
- delegate(address) is a public function that delegates for msg.sender (dossier source)
- approve(address,uint256) also present for the token's own approvals

## Impact and exposure

- Value held at block 26,438,999: $39,339 (ETH and 49 priced tokens, over 24 addresses).
- Activity: 83,930 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls delegate(address) itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
