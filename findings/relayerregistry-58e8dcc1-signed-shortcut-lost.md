---
id: relayerregistry-58e8dcc1-signed-shortcut-lost
title: "RelayerRegistry: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x58e8dcc13be9780fc42e8723d8ead4cf46943df2"
  family: "0164618db5569fe0d5e4506290723c20"
  copies: 2
  name: "RelayerRegistry"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 21954
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "the affected signer, by calling directly"
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
  note: "LOW: same act via approve + register/stakeToRelayer."
---

## Summary

Tornado RelayerRegistry: registerPermit/stakeToRelayerPermit pull TORN via torn.permit signed by the relayer/staker.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read (function text).
- RelayerRegistry.sol:122,250 torn.permit(relayer|staker, ...)
- RelayerRegistry.sol:104 register(...) and l.232 stakeToRelayer(...) are the direct paths after a TORN approve

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 21,954 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

affected party uses the direct call

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
