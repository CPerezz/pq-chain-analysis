---
id: 00000000-sender-gas-limits
title: "0x00000000 (tagged Biconomy: MEE K1 Validator v1.0.3 (MEE v2.1.0)): transactions fail with the sender's gas limit"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x0000000031ef4155c978d48a8a7d4edba03b04fe"
  family: "249ca13b9caba6a2f790f608ce304abc"
  copies: 2
  label: "Biconomy: MEE K1 Validator v1.0.3 (MEE v2.1.0)"
  upgradeable: "no"
  rating: LOW
  txs_90d: 2155
  last_active: 2026-11-16
  recoveries_14d: 208
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

unverified contract: a call path running ecrecover failed under EIP-8151's higher precompile cost with the sender's tight gas limit and succeeded with more gas.

## Mechanism

PQ-18. The contracts are unchanged: whoever sets the gas limit (sender, relayer, keeper) gives up to 3,100 gas less than each recovery now needs.

## Evidence

- How it was placed: a real transaction fails with the gas its sender gave and passes with more: 0xa6f9fbc4ba933669b474ceb9528ab2fd2cd26427c32f3233d3072a04bcb02a04 (block 26369135). The sender's limit was tight, not the…. Executed.
- Row note states the study replay: tx 0xa6f9fbc4ba933669b474ceb9528ab2fd2cd26427c32f3233d3072a04bcb02a04 (block 26369135) fails under EIP-8151 with the sender's gas limit and passes with more ('Executed'); study reading1_class: 'fails only with the sender's old gas limit'.
- Bytecode of 0x0000000031ef4155c978d48a8a7d4edba03b04fe at block 26438999 (cast code): every STATICCALL/CALL to the ecrecover path takes GAS as the gas argument (no hard-coded gas) — source grep found no literal-gas staticcall to 0x1.
- Only literal-gas staticcall (0xffff) targets 0x378edcd5…, not 0x01; the ecrecover call is PUSH1 0x01 GAS STATICCALL.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,155 transactions called it in the 90 days before that block; last on 2026-11-16.
- 208 signature recoveries in the study's two-week trace window.

## Remediation

Senders/relayers re-estimate gas or add headroom after EIP-8151; no contract change needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-sender-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
