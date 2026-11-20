---
id: degens-88888888-signed-shortcut-lost
title: "Degens: signed shortcut lost by users with code"
status: confirmed
severity: MEDIUM
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x8888888883585b9a8202db34d8b09d7252bfc61c"
  family: "279c46a28b0aef13f091d5f0c9ccfc4a"
  name: "Degens"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 39700
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-22
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
  note: "No direct way to make an order: the maker role dies for code accounts, but nothing is locked (no held balances; recoverFunds settles) → MEDIUM, matching peers' exchange-without-on-chain-orders calls. Arguable LOW because taking stays open; flagged."
---

## Summary

Degens sports-betting exchange: every order must recover to its maker; under EIP-8151 a maker with code cannot have orders filled, and grader-signed claims fail for a grader with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Degens (sports betting): every order must recover to its maker (no ERC-1271), so a maker with code cannot have orders matched; withdrawals are direct. A match is graded by the graders committed in…. Read by hand.
- unpackOrder: ecrecoverPacked(...) == o.maker, no ERC-1271 and no on-chain order book (Degens.sol:176)
- trade() lets msg.sender take others' orders; balances are pulled by transferFrom/allowance, not held (Degens.sol:233-261, 446-541)
- recoverFunds lets anyone finalise a match at its cancel price after recoveryTime, without graders (Degens.sol:399-419)
- No setter or upgrade path (facts: setters [], upgrades [])

## Impact and exposure

- Value held at block 26,438,999: $39,700 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-22.

## Remediation

None in-contract; a code-holding account can still take orders, and stuck matches finalise via recoverFunds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
