---
id: d1901bd2-signed-shortcut-lost
title: "0xd1901bd2: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xd1901bd2063d2c8f649bf31b6df6d0f853a6bda3"
  family: "6b096f928057c3d21c39f86646c1068b"
  copies: 4
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 38618
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody (operator keeps its bankroll)"
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
  rating: MEDIUM
  note: "No direct user path for the signed act, so LOW does not hold; no user funds shown waiting on a signature and the bankroll is the operator's → MEDIUM. Bytecode only; flagged."
---

## Summary

Betting bankroll (unverified): operators submit users' signed bets; under EIP-8151 a user with code cannot place signed bets.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: betting bankroll (4 contracts, 21 ETH with tokens): operators submit users' signed bets. A user with code cannot place signed bets; no direct user entry is visible in the decompiled functions, and…. Bytecode and names.
- Decompile: the two entries with ecrecover (0x4e0d6e18, 0x06aec506) are gated by an operator map storage_map_f[msg.sender] (heimdall, scratch L027)
- No user withdraw entry found; adminWithdrawAmount and the other money paths require msg.sender == owner (heimdall)
- No permit/approve selectors; only transferOwnership as setter (facts)

## Impact and exposure

- Value held at block 26,438,999: $38,618 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None; users with code cannot bet here.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
