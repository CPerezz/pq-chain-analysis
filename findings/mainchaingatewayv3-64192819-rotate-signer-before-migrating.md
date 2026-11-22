---
id: mainchaingatewayv3-64192819-rotate-signer-before-migrating
title: "MainchainGatewayV3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x64192819ac13ef72bf6b5ae239ac672b43a9af08"
  family: "2660d36cc9f0c28c56d755455401268a"
  copies: 2
  name: "MainchainGatewayV3"
  label: "Axie Infinity: Ronin Bridge V2"
  upgradeable: "yes"
  rating: LOW
  value_usd: 1125504
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3292
  last_active: 2026-11-15
  recoveries_14d: 2624
fix:
  layer: onchain-config
  who_acts: "Ronin bridge manager / proxy admin"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW given a live governance admin. The reading's own MEDIUM assumed no rotation; the bridge manager address was not read."
---

## Summary

Ronin MainchainGatewayV3. Operator signatures are weighted; withdrawals stop if operators above the margin migrate.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: recovered signers in ascending order, each with a weight read from the bridge manager; a minimum weight is needed. Read from source. Executed: a real transaction reverts with code at the signer.
- reading 2660d36c: the BRIDGE_MANAGER rotates operators; the proxy admin can setContract or upgrade
- 1967 admin = 0x2cf3cfb1 (2,391-byte contract, getThreshold 7); gateway getThreshold 70, paused false

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3,292 transactions called it in the 90 days before that block; last on 2026-11-15.
- 2,624 signature recoveries in the study's two-week trace window.

## Remediation

The bridge manager rotates operator addresses.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
