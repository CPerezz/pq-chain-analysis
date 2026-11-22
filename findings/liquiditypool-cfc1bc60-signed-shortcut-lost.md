---
id: liquiditypool-cfc1bc60-signed-shortcut-lost
title: "LiquidityPool: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0xcfc1bc6013ed89d484c626dd9ee5eb7bc1a1d9da"
  family: "adb08b465cdeff594e3ffd81de34c9f2"
  copies: 2
  name: "LiquidityPool"
  upgradeable: "yes"
  rating: LOW
  value_usd: 318144
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 849
  last_active: 2026-11-18
  recoveries_14d: 139
fix:
  layer: account-migration
  who_acts: "the user"
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
  note: "Same acts open by direct path → LOW. The maintainer-key part is a separate (rotate-signer) issue."
---

## Summary

LiquidityPool (UUPS): relayed swap/lock paths need the user's ECDSA signature; a user with code loses them.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: the user named must have signed the swap (ECDSA only); sent by a role holder / the user named must have signed the lock (ECDSA only); sent by a role holder / the recovered address must be the stored…. Read from source. Executed: a real transaction reverts with code at the signer.
- LiquidityPool.sol:316 singleChainSwap callable by the user directly (msg.sender is the swapper)
- lockSource pulls from a direct approve allowance; only routing role checked
- UUPS proxy, upgrade needs UPGRADER_ROLE (row upgradeable yes)

## Impact and exposure

- Value held at block 26,438,999: $318,144 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 849 transactions called it in the 90 days before that block; last on 2026-11-18.
- 139 signature recoveries in the study's two-week trace window.

## Remediation

User swaps via singleChainSwap or approves and uses lockSource.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
