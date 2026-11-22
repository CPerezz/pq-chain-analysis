---
id: bridge-0fa0b4cc-signed-shortcut-lost
title: "Bridge: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x0fa0b4cc33d5a4f0ed073ca7f88259ab75c7a98b"
  family: "e9bf1caf3fc3c4ae8032e150ab4e096f"
  copies: 4
  name: "Bridge"
  label: "RSK: Token Bridge"
  upgradeable: "yes"
  rating: LOW
  value_usd: 836233
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the recipient"
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
  note: "Same act (claim) open by direct call → LOW."
---

## Summary

RSK Token Bridge: claimGasless lets a relayer claim for the recipient who signed; a recipient with code fails the signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: bridge claimGasless: the recipient named must have signed to let a relayer claim for a fee. Read from source.
- Bridge.sol:1583 claim(ClaimData) pays _claimData.to with no signature, callable by anyone
- Bridge.sol:1595 claimFallback for the original sender
- proxy upgradeable (row)

## Impact and exposure

- Value held at block 26,438,999: $836,233 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Recipient (or anyone) calls claim directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
