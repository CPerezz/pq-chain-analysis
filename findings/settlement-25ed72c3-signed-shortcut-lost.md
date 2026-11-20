---
id: settlement-25ed72c3-signed-shortcut-lost
title: "Settlement: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x25ed72c3f671b626810a6db597dcfd50f215a423"
  family: "a4c84274487665921947e42874836ae8"
  name: "Settlement"
  upgradeable: "no"
  rating: LOW
  txs_90d: 10163
  last_active: 2026-11-12
  recoveries_14d: 523
fix:
  layer: offchain
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "Same party keeps a direct path (setPreSignature) and an ERC-1271 scheme; only already-signed ECDSA orders are lost."
---

## Summary

CoW-style Settlement: orders signed with the EIP-712/EthSign schemes stop recovering once the owner's address has code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: CoW-style settlement _processSingleTrade: passes the trade on / CoW-style recoverOrderFromTrade: takes the owner from recoverOrderSigner and requires it to be the order's owner / CoW-style…. Read from source. Executed: a real transaction reverts with code at the signer.
- src/mixins/Signing.sol:145 recoverOrderSigner supports Eip712, EthSign, Eip1271 (isValidSignature at :292) and PreSign schemes
- Signing.sol:92 setPreSignature(orderUid,bool) is callable by the order owner directly

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 10,163 transactions called it in the 90 days before that block; last on 2026-11-12.
- 523 signature recoveries in the study's two-week trace window.

## Remediation

Owner pre-signs orders via setPreSignature (or uses the EIP-1271 scheme); offchain re-signing of open orders.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
