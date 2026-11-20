---
id: stakedaavev3-0fe58fe1-signed-shortcut-lost
title: "StakedAaveV3: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x0fe58fe1caa69951dc924a8c222be19013b89476"
  family: "8331b4fc7a7a197330e593b45cd126c1"
  copies: 2
  name: "StakedAaveV3"
  label: "Aave: Staked Aave"
  upgradeable: "no"
  rating: LOW
  value_usd: 273781708
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 10264
  last_active: 2026-11-18
  recoveries_14d: 3
fix:
  layer: account-migration
  who_acts: "the holder"
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

Aave StakedAaveV3: metaDelegate/metaDelegateByType recover the delegator; a delegator with code fails.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: metaDelegateByType: the delegator named must equal the recovered address; it can call delegateByType itself / metaDelegate: the delegator named must equal the recovered address; it can call delegate…. Read from source. Executed: a real transaction reverts with code at the signer.
- BaseDelegation.sol:93 delegate and :84 delegateByType are direct calls by the delegator
- permit has standard approve

## Impact and exposure

- Value held at block 26,438,999: $273.8M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 10,264 transactions called it in the 90 days before that block; last on 2026-11-18.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Delegator calls delegate/delegateByType or approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
