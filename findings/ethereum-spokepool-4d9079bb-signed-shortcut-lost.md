---
id: ethereum-spokepool-4d9079bb-signed-shortcut-lost
title: "Ethereum_SpokePool: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x4d9079bb4165aeb4084c526a32695dcfd2f77381"
  family: "51de8102eac1f311da6630f11f247dbd"
  copies: 2
  name: "Ethereum_SpokePool"
  label: "Across Protocol: Old Ethereum Spoke Pool V2"
  upgradeable: "no"
  rating: LOW
  value_usd: 433
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 16
  last_active: 2026-09-23
fix:
  layer: none
  who_acts: "nobody for funds; the team adds ERC-1271 to keep gasless flows"
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
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks"
---

## Summary

`Ethereum_SpokePool` at `0x4d9079bb4165aeb4084c526a32695dcfd2f77381` (Etherscan tag: Across Protocol: Old Ethereum Spoke Pool V2), with 1 more addresses running its code. It lets a user act through an ECDSA signature or by a direct call; a user whose account has code loses the signed path only.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Across SpokePool speedUpDeposit: the depositor named must sign a fee update (ECDSA only); the deposit still fills or refunds without it. Read.
- Reviewed through the root issue's mechanism: the reading states a direct path for the signed act (approve next to permit, delegate next to delegateBySig, castVote next to castVoteBySig, a direct call next to a meta-transaction, or an order the maker can place or approve on chain), so a holder whose account has code keeps the act: LOW
- Mechanical checks: where the reading names permit, delegateBySig or castVoteBySig, this address's code holds that function and its direct twin; the scanner finds an ecrecover call in the code
- A random sample of 25 of the 18,891 rows below Anon's thresholds: 24 held at LOW, 1 (an NFT exchange whose orders can only be signed) was MEDIUM; readings of that kind were sent to one-by-one checks

## Impact and exposure

- Value held at block 26,438,999: $433 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 16 transactions called it in the 90 days before that block; last on 2026-09-23.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
