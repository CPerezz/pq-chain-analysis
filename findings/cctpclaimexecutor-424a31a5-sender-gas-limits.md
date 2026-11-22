---
id: cctpclaimexecutor-424a31a5-sender-gas-limits
title: "CctpClaimExecutor: transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x424a31a57f7c63918ecaa2fac38016a8af5a6ec2"
  family: "46b9bf64958a11a4d6fd17668bd014d8"
  name: "CctpClaimExecutor"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2165
  last_active: 2026-11-18
  recoveries_14d: 247
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

CctpClaimExecutor: a call path running ecrecover failed under EIP-8151's higher precompile cost with the sender's tight gas limit and succeeded with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0x03fb1cd3f944600171b0a0ac17993cae5d8cb8e040ba81e914802638efe25d2b (block 26409634). The sender's limit was tight, not the…. Executed.
- Row note states the study replay: tx 0x03fb1cd3f944600171b0a0ac17993cae5d8cb8e040ba81e914802638efe25d2b (block 26409634) fails under EIP-8151 with the sender's gas limit and passes with more ('Executed'); study reading1_class: 'fails only with the sender's old gas limit'.
- Bytecode of 0x424a31a57f7c63918ecaa2fac38016a8af5a6ec2 at block 26438999 (cast code): every STATICCALL/CALL to the ecrecover path takes GAS as the gas argument (no hard-coded gas) — source grep found no literal-gas staticcall to 0x1.
- Source has staticcall(5000, token, ...) but it targets a token (balance/decimals query), not ecrecover.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,165 transactions called it in the 90 days before that block; last on 2026-11-18.
- 247 signature recoveries in the study's two-week trace window.

## Remediation

Senders/relayers re-estimate gas or add headroom after EIP-8151; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
