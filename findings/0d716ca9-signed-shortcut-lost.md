---
id: 0d716ca9-signed-shortcut-lost
title: "0x0d716ca9: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x0d716ca9fc2bfd8c66d2af2fb38b56d08809a8cc"
  family: "7a4557765b7d4c65b6e91084a752fbae"
  copies: 3
  upgradeable: "yes"
  rating: LOW
  value_usd: 5414
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2503
  last_active: 2026-11-18
  recoveries_14d: 1
fix:
  layer: contract-upgrade
  who_acts: "the core's timelock owner upgrades it"
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
  rating: LOW
  note: "A UUPS proxy owned by a live timelock (read for batch 015, rows 0x5302fa39 and 0x6c3fb358, whose only caller is this core): a live upgrade path fixes it, so LOW."
---

## Summary

UUPS proxy (impl 0x9d307cdd…, deposit/depositFor/setRole/whitelist): a named party signs an action the proxy relays. A real transaction reverts with code at the signer. The study itself didn't establish a direct entry.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a named party signs an action relayed through the proxy; whether it has a direct entry is not established. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- facts: upgradeToAndCall present, owner() = 0x919bf7ba… (a contract, nonce 1, not a Safe: getThreshold/getOwners revert)
- heimdall decompile of the implementation shows no inline ecrecover (it delegates further); the signed function not identified

## Impact and exposure

- Value held at block 26,438,999: $5,414 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 2,503 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Unknown until read.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
