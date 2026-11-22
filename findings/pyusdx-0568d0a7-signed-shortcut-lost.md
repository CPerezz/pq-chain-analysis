---
id: pyusdx-0568d0a7-signed-shortcut-lost
title: "PYUSDX: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x0568d0a74145fd557b3541897bc6878f5c6e9c8c"
  family: "742cdc781aed843f87f66dc3c36de4ad"
  copies: 2
  name: "PYUSDX"
  label: "deployed by M0: Deployer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2834
  last_active: 2026-11-17
  recoveries_14d: 1
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
  note: "ECDSA-only overloads lost; approve/transfer and the bytes ERC-1271 overloads remain → LOW"
---

## Summary

PYUSDX (M extensions ERC20Extended): permit(v,r,s) is ECDSA-only; permit(bytes) and ERC-3009 bytes overloads fall back to ERC-1271.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: ECDSA first; if it fails the signer's ERC-1271 is asked / returns the recovered signer to its caller / permit: the owner named in the call must equal the recovered address; the holder can call…. Read from source.
- ERC712ExtendedUpgradeable._revertIfInvalidSignature(bytes): ECDSA first, else isValidERC1271Signature
- v,r,s and r,vs overloads: validateECDSASignature only → lost for a holder with code
- ERC20ExtendedUpgradeable.approve/transfer: msg.sender-based

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,834 transactions called it in the 90 days before that block; last on 2026-11-17.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
