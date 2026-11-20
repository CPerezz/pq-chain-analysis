---
id: stabletokenv1oft-27f6c828-signed-shortcut-lost
title: "StableTokenV1OFT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x27f6c8289550fce67f6b50bed1f519966afe5287"
  family: "03a528d4e5850fbe16995dee53057f48"
  copies: 6
  name: "StableTokenV1OFT"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 5508
  last_active: 2026-11-18
  recoveries_14d: 24
fix:
  layer: none
  who_acts: "the affected holder (calls the direct function itself)"
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
  note: "Standard signed shortcut; approve remain open to the same holder."
---

## Summary

StableTokenV1OFT: permit stops working for a holder whose address has code; the act stays open by direct call.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- bytecode (proxy+implementation 0x94321d80d3c5cdac63b75f723ae64ca7f94be547) exposes approve(address,uint256) 0x095ea7b3 and transfer 0xa9059cbb
- study note: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 5,508 transactions called it in the 90 days before that block; last on 2026-11-18.
- 24 signature recoveries in the study's two-week trace window.

## Remediation

Holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
