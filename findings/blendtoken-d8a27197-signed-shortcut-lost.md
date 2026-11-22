---
id: blendtoken-d8a27197-signed-shortcut-lost
title: "BlendToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd8a271974e8edae9d7b58e3370dc1669427503f4"
  family: "4fdee883746a1f70df1a7a6b37878fb6"
  copies: 2
  name: "BlendToken"
  label: "Fluent: BLEND Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 24746
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost. Partial 1271 support exists for some variants, not the v,r,s permit."
---

## Summary

BlendToken: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / SignatureChecker on the account named: ECDSA, else the account's ERC-1271. Read from source.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- bytes-signature variants go through SignatureChecker (ECDSA, else ERC-1271); the v,r,s permit is pure ECDSA
- row note: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / SignatureChecker on the account named: ECDSA, else the account's ERC-1271. Read from source.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 24,746 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
