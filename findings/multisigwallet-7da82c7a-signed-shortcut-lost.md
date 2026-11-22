---
id: multisigwallet-7da82c7a-signed-shortcut-lost
title: "MultiSigWallet: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9"
  family: "077a160a57be207b3427b9030cf32233"
  copies: 3
  name: "MultiSigWallet"
  label: "Golem: Multisig"
  upgradeable: "no"
  rating: LOW
  value_usd: 17205216
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "multisig owners"
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
  note: "Same act (confirm) open by direct call for the same owner → LOW."
---

## Summary

Old Gnosis MultiSigWallet (Golem): signed confirmations recover owners; an owner with code cannot confirm by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: old Gnosis MultiSigWallet modifier: every signature must recover to an owner; owners can also confirm by their own call / old Gnosis MultiSigWallet: adds a confirmation for each owner recovered from…. Read from source.
- MultiSigWallet.sol:168 confirmTransaction(bytes32) is a direct call by an owner
- MultiSigWallet.sol:144 submitTransaction and :185 executeTransaction are direct calls

## Impact and exposure

- Value held at block 26,438,999: $17.2M (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners confirm by their own transaction.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
