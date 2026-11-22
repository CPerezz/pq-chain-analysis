---
id: sportcrypt-37304b0a-signed-shortcut-lost
title: "SportCrypt: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x37304b0ab297f13f5520c523102797121182fb5b"
  family: "bca8e068aa339616f9e84780d1f28fa0"
  name: "SportCrypt"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 38978
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-24
fix:
  layer: none
  who_acts: "nobody (no update path)"
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
  rating: MEDIUM
  note: "Making orders has no direct path, so LOW does not hold; nothing is locked (direct withdraw, recoverFunds) → MEDIUM, as peers rated exchanges without on-chain orders."
---

## Summary

SportCrypt sports-betting exchange: orders must recover to their maker and final prices must be signed by an admin; under EIP-8151 a maker with code cannot place orders.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: SportCrypt order: the maker named must have signed / SportCrypt claim: the final price must be signed by an admin. Read from source.
- validateOrderSig: ecrecover(...) != o.addr → false; no on-chain order path (SportCrypt.sol:104-106, 167)
- withdraw(uint) pays msg.sender's balance directly (SportCrypt.sol:139-152)
- claim needs an admin signature, admins set by owner via addAdmin/removeAdmin; recoverFunds finalises a match after its recovery time without admins (SportCrypt.sol:20-27, 207-264)

## Impact and exposure

- Value held at block 26,438,999: $38,978 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-24.

## Remediation

None for makers with code; balances leave by withdraw, matches settle via admin or recoverFunds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
