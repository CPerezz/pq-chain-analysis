---
id: htlc-e92fa4e3-signed-shortcut-lost
title: "Htlc: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xe92fa4e3447a58753154364b329d2361b3b4cae4"
  family: "9ec7baa4a74c324cd5e6a7075cfcae25"
  name: "Htlc"
  upgradeable: "no"
  rating: LOW
  value_usd: 37174
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "the lock owner"
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
  note: "The same refund stays open by a direct call after the timeout → LOW. value $37174, txs_90d 0."
---

## Summary

HTLC/two-party lock: earlyResolve needs the other party's ECDSA signature; under EIP-8151 a counterparty with code cannot sign it.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Htlc earlyResolve: the caller is one party of the two-party lock and the other must have signed; expiry paths exist by name. Read from source.
- earlyResolve: caller is owner or authority, the other one must sign (Htlc.sol:251-265)
- timeoutResolve returns the deposit to the owner after unlockTime, callable by anyone, no signature (Htlc.sol:273-280)
- Swaps also have reclaimExpiredSwap (Htlc.sol:394)

## Impact and exposure

- Value held at block 26,438,999: $37,174 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Wait for unlockTime and call timeoutResolve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
