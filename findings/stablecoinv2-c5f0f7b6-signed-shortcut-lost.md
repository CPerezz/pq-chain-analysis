---
id: stablecoinv2-c5f0f7b6-signed-shortcut-lost
title: "StablecoinV2: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc5f0f7b66764f6ec8c8dff7ba683102295e16409"
  family: "0b71442ba97feb2fb11fa5da28836bf3"
  copies: 2
  name: "StablecoinV2"
  label: "First Digital USD: FDUSD Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 3144
  last_active: 2026-11-18
  recoveries_14d: 2
fix:
  layer: offchain
  who_acts: "the holder (calls approve/delegate/transfer directly)"
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
  note: "permit and the v,r,s authorization lost; approve/transfer and the ERC-1271 overload remain → LOW"
---

## Summary

FDUSD (StablecoinV2, proxy): OZ4 permit is ECDSA-only; transferWithAuthorization bytes overload uses SignatureChecker (ECDSA, else ERC-1271).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / SignatureChecker on the account named: ECDSA, else the account's ERC-1271. Read from source. Executed: a real transaction reverts with code at the signer.
- StablecoinV2.sol:240 transferWithAuthorization(bytes) uses SignatureCheckerUpgradeable.isValidSignatureNow → ERC-1271 for a signer with code
- OZ4 ERC20PermitUpgradeable permit: ECDSA only, lost for a holder with code
- approve/transfer in code, callable by the holder

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,144 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
