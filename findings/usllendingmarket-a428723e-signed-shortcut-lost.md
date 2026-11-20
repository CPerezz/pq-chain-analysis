---
id: usllendingmarket-a428723e-signed-shortcut-lost
title: "USLLendingMarket: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xa428723ee8ffd87088c36121d72100b43f11fb6a"
  family: "80f924512671c1a1f1525c82249cef38"
  name: "USLLendingMarket"
  upgradeable: "no"
  rating: LOW
  value_usd: 20924775
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2464
  last_active: 2026-11-18
  recoveries_14d: 3
fix:
  layer: account-migration
  who_acts: "the authorizer"
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
  note: "Same act open by direct call → LOW."
---

## Summary

Morpho-style lending market: setAuthorizationWithSig recovers the authorizer; an authorizer with code fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Morpho setAuthorizationWithSig: the authorizer named must have signed; zero rejected. Read from source.
- src/lending_market/LendingMarket.sol:541 setAuthorization(authorized,bool) is a direct call by msg.sender
- positions are managed directly by their owner

## Impact and exposure

- Value held at block 26,438,999: $20.9M (ETH and 49 priced tokens).
- Activity: 2,464 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Authorizer calls setAuthorization directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
