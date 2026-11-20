---
id: 6c3fb358-fixed-signer
title: "0x6c3fb358: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6c3fb358a7900e1fde64c543492d2f3d03b5e6bc"
  family: "54bd98588ad6c299c248d8964bc0a668"
  copies: 3
  upgradeable: "yes"
  admin: "TimelockController 0x919bf7ba0795bb7e69d6920864ecb3861a2359dd via core UUPS"
  rating: LOW
  txs_90d: 879
  last_active: 2026-11-18
  recoveries_14d: 552
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
  note: "The caller is upgradeable by a live admin, so LOW."
---

## Summary

Another adapter of the same oracle family as 0x5302…: it accepts only the constant co-signer 0x35c55561… and only calls from the UUPS core 0x0d716ca9…, which a live timelock owns.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: ecrecover at pc 1702; PUSH32 constants 0x35c55561f08c4a3549817ab6e1a6a9093c2c955c (signer, no code) and 0x0d716ca9fc2bfd8c66d2af2fb38b56d08809a8cc (core)
- core implementation 0x9d307cdd… has upgradeToAndCall; owner 0x919bf7ba… is a TimelockController
- adapter holds 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 879 transactions called it in the 90 days before that block; last on 2026-11-18.
- 552 signature recoveries in the study's two-week trace window.

## Remediation

Core owner swaps in a new adapter with a fresh signer, or upgrades the core.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
