---
id: voxelxminer-ba0de108-sender-gas-limits
title: "voxelXMiner: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0xba0de1085f6ecbc037b6b5d24ab76d2cff9d0a24"
  family: "d8e0ddf3111432d21af91188a4b1bde5"
  copies: 12
  name: "voxelXMiner"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2363
  last_active: 2026-11-18
  recoveries_14d: 742
fix:
  layer: offchain
  who_acts: "transaction senders (raise gas limit / re-estimate)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-sender-gas-limits"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Replay stated in the note and contract forwards all gas to ecrecover, so not fixed-gas-recovery; a gas-limit fix is LOW by nature."
---

## Summary

voxelXMiner: a call path running ecrecover failed under EIP-8151's higher precompile cost with the sender's tight gas limit and succeeded with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xb174d9c7ef8ea5df54d0b7c2a2a423ac1f731f2559aa0f2f4c149b813d0dc199 (block 26413945). The sender's limit was tight, not the…. Executed.
- Row note states the study replay: tx 0xb174d9c7ef8ea5df54d0b7c2a2a423ac1f731f2559aa0f2f4c149b813d0dc199 (block 26413945) fails under EIP-8151 with the sender's gas limit and passes with more ('Executed'); study reading1_class: 'fails only with the sender's old gas limit'.
- Bytecode of 0xba0de1085f6ecbc037b6b5d24ab76d2cff9d0a24 at block 26438999 (cast code): every STATICCALL/CALL to the ecrecover path takes GAS as the gas argument (no hard-coded gas) — source grep found no literal-gas staticcall to 0x1.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 2,363 transactions called it in the 90 days before that block; last on 2026-11-18.
- 742 signature recoveries in the study's two-week trace window.

## Remediation

Senders/relayers re-estimate gas or add headroom after EIP-8151; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
