---
id: kalidao-36a1e54a-signed-shortcut-lost
title: "KaliDAO: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x36a1e54a51639693779bc8a121724aa446f3f57c"
  family: "32c95a5ffa31c9f3b15e99be13c5c8b4"
  copies: 84
  name: "KaliDAO"
  upgradeable: "no"
  rating: LOW
  value_usd: 17504
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5
  last_active: 2026-11-02
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $17504, txs_90d 5."
---

## Summary

KaliDAO token/governor: permit, delegateBySig and voteBySig; under EIP-8151 a member with code cannot use them.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: KaliDAO permit / KaliDAO delegateBySig / KaliDAO voteBySig: the signer named must have signed. Read from source.
- KaliDAO permit, delegateBySig and voteBySig recover to the named signer (KaliDAO.sol:184, 261)
- approve (133), delegate (257) and vote (851) are direct entries for the same account
- Same party in all three pairs

## Impact and exposure

- Value held at block 26,438,999: $17,504 (ETH and 49 priced tokens, over 84 addresses).
- Activity: 5 transactions called it in the 90 days before that block; last on 2026-11-02.

## Remediation

The member calls approve / delegate / vote directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
