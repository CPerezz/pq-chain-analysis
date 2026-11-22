---
id: aletheanft-c2d6b32e-signed-shortcut-lost
title: "AletheaNFT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc2d6b32e533e7a8da404abb13790a5a2f606ad75"
  family: "dbf1176ee51c253c077cf432ada13328"
  copies: 7
  name: "AletheaNFT"
  label: "deployed by Alethea AI: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 29234
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 376
  last_active: 2026-11-16
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $29234, txs_90d 376."
---

## Summary

AletheaNFT exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: NFT permit and permitForAll (read): the owner named must sign; it can approve by calling the contract itself. Read by hand.
- NFT permit and permitForAll: the owner named must be the ECDSA signer (dossier source, AletheaNFT)
- approve and setApprovalForAll are direct entries for the owner (dossier source)
- Same party in both paths

## Impact and exposure

- Value held at block 26,438,999: $29,234 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 376 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

The owner calls approve / setApprovalForAll itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
