---
id: nativelbtc-1b53b627-signed-shortcut-lost
title: "NativeLBTC: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x1b53b6279bcba8428013aa9aad1bad6d4dd80cf4"
  family: "daf86a8f6c0b6c692dcf9afd2d24b6e4"
  copies: 2
  name: "NativeLBTC"
  label: "Lombard: BTC.b Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2341
  last_active: 2026-11-18
  recoveries_14d: 38
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
  note: "signed shortcut only; the same act stays open to the same party by direct call → LOW"
---

## Summary

NativeLBTC is an ERC-20 with permit; under EIP-8151 a holder whose address has non-delegation code can no longer use the signed path.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / Lombard checkSignature: a signer with code is asked through ERC-1271, otherwise ECDSA.recover must equal it. Read from source. Executed: a real transaction reverts with code at the signer.
- OZ5 permit: ECDSA.recover == owner, lost for a holder with code
- approve/transfer selectors in code (msg.sender-based)
- Lombard checkSignature asks ERC-1271 when the signer has code (EIP1271SignatureUtils.sol), so that site is not hit

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,341 transactions called it in the 90 days before that block; last on 2026-11-18.
- 38 signature recoveries in the study's two-week trace window.

## Remediation

holder uses approve/delegate/transfer from its own address instead of the signature

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
