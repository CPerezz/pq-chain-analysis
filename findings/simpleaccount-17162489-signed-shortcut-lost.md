---
id: simpleaccount-17162489-signed-shortcut-lost
title: "SimpleAccount: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x17162489643970027c6c8a91015ef752b30eb7f3"
  family: "64d06ec8096a703f7c70ce05b6c2e02b"
  copies: 3776
  name: "SimpleAccount"
  upgradeable: "yes"
  rating: LOW
  value_usd: 8662
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 6867
  last_active: 2026-11-17
  recoveries_14d: 588
fix:
  layer: account-migration
  who_acts: "account owner with code"
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
  note: "Direct path, same party. Value $8662, txs_90d 6867 (not rating inputs)."
---

## Summary

ERC-4337 SimpleAccount: user operations need the owner's ECDSA signature. If the owner address gets code, the owner can still call execute/executeBatch directly and can upgrade the account.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SimpleAccount: user operations need the owner's ECDSA signature and the owner has no setter; execute also accepts a direct call from the owner (read), and the owner may upgrade the code. Read (same text as a family read). Executed: a real transaction reverts with code at the signer.
- source SimpleAccount.sol:58 execute → _requireFromEntryPointOrOwner(): msg.sender == entryPoint
- msg.sender == owner
- row: upgradeable yes (UUPS by owner)

## Impact and exposure

- Value held at block 26,438,999: $8,662 (ETH and 49 priced tokens, over 3,776 addresses).
- Activity: 6,867 transactions called it in the 90 days before that block; last on 2026-11-17.
- 588 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls execute directly or upgrades the account to a 1271-aware validator.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
