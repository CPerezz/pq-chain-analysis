---
id: 5302fa39-fixed-signer
title: "0x5302fa39: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5302fa390a0af7c9a85938e71a7fe8cf9ce9bf35"
  family: "40e3a787ff0664b7804765714d133e28"
  copies: 3
  upgradeable: "yes"
  admin: "TimelockController 0x919bf7ba0795bb7e69d6920864ecb3861a2359dd via core UUPS upgradeToAndCall"
  rating: LOW
  txs_90d: 1644
  last_active: 2026-11-18
  recoveries_14d: 2941
fix:
  layer: contract-upgrade
  who_acts: "TimelockController 0x919bf7ba0795bb7e69d6920864ecb3861a2359dd (owner of the core)"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The adapter is fixed, but its only caller is upgradeable by a live admin, so LOW."
---

## Summary

Oracle adapter that requires an EIP-712 co-signature by the constant 0x35c55561… and can only be called by the core 0x0d716ca9…. That core is a UUPS proxy owned by a live timelock, so the core can be upgraded or repointed.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: checks against a verifier that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: one ecrecover (pc 5406) compared to a constant; getter 0x8c72c54e returns 0x35c55561f08c4a3549817ab6e1a6a9093c2c955c, which has no code
- 0xac22bd8c requires msg.sender == 0x0d716ca9fc2bfd8c66d2af2fb38b56d08809a8cc (heimdall)
- core EIP-1967 implementation = 0x9d307cdd…, which exposes upgradeToAndCall; owner() = 0x919bf7ba… (TimelockController selectors, getMinDelay 0)
- adapter holds 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,644 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,941 signature recoveries in the study's two-week trace window.

## Remediation

Core owner deploys a new adapter with a fresh signer and upgrades or reconfigures the core to use it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
