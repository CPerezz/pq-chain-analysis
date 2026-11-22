---
id: 7348ed38-signed-shortcut-lost
title: "0x7348ed38: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x7348ed38bdc1fa2de2061bf202d6ee7bd72e9cb8"
  family: "312d48b85c6ef2d0a831d45117c6ce6a"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1713
  last_active: 2026-11-18
  recoveries_14d: 244
fix:
  layer: offchain
  who_acts: "the holder (transfers the token directly)"
evidence:
  level: bytecode
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
  note: "relay convenience lost; nothing held → LOW. Bytecode only"
---

## Summary

Unverified relayer: executeTransfer moves a holder's tokens via transferFrom on the holder's signature; with code at the holder it reverts.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: executeTransfer: the holder named signs a relayed transfer. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- only selectors: executeTransfer(address,address,address,uint256,uint256,bytes) and lastNonce(address,address)
- tokens stay in the holder's wallet (pulled by transferFrom on its approval); holder can call token.transfer itself
- txs_90d 1713, recoveries_14d 244

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,713 transactions called it in the 90 days before that block; last on 2026-11-18.
- 244 signature recoveries in the study's two-week trace window.

## Remediation

holder transfers directly or revokes the approval

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
