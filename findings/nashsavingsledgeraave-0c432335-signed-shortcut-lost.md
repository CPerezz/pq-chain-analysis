---
id: nashsavingsledgeraave-0c432335-signed-shortcut-lost
title: "NashSavingsLedgerAave: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x0c432335a0f4280d348e5ff865e02cc5e9562b3d"
  family: "c5f631438e73d8218c77f208e5a695de"
  name: "NashSavingsLedgerAave"
  upgradeable: "no"
  rating: LOW
  value_usd: 49986
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the saver"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $49986, txs_90d 0."
---

## Summary

Nash savings ledger over Aave aTokens: owner-submitted balance updates that lower a user balance need that user's ECDSA signature; under EIP-8151 a user with code cannot sign those.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Nash savings ledger: a balance update must be signed by the user it names / Aave v2 aToken permit: the owner named must have signed. Read from source.
- verifyProof: negative deltas require ecrecover(...) == update.user, no ERC-1271 (NashSavingsLedgerAave.sol:161-179)
- withdraw(uint[5]) lets msg.sender withdraw its own ledger balance directly (NashSavingsLedgerAave.sol:291-323)
- The AToken permit in the bundle is Aave's library code, not this contract's entry

## Impact and exposure

- Value held at block 26,438,999: $49,986 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The user withdraws by its own withdraw() call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
