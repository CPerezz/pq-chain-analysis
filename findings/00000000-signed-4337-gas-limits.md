---
id: 00000000-signed-4337-gas-limits
title: "0x00000000: signed ERC-4337 verification gas too small"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x000000000804ff442be7d200445362c46a008add"
  family: "f441c4cb49a72abfcfc0ccbd58df3d5d"
  copies: 3
  upgradeable: "yes"
  rating: LOW
  txs_90d: 26339
  last_active: 2026-11-18
  recoveries_14d: 1174
fix:
  layer: offchain
  who_acts: "bundlers/wallet software estimating gas after EIP-8151 activates; separately, updateVerifyingSigner's owner"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-4337-gas-limits"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Matches the root issue: a real failure at the old signed limit, passing with a bigger re-estimated limit. LOW by nature."
---

## Summary

A verifying ERC-4337 paymaster (3 copies). The EntryPoint calls it with the user operation's signed paymasterVerificationGasLimit (30,000); that budget, not the paymaster's own code, sizes the ecrecover.

## Mechanism

PQ-18. The verification gas limit is signed into the operation, so only a new signature with a higher limit helps.

## Evidence

- How it was placed: traced: an ERC-4337 bundle; this verifying paymaster is called by the EntryPoint with the paymaster verification gas limit of each user operation (30,000), which is signed in the operation. With the…. Executed and traced.
- row study reading1 (traced): the recovery being 3,100 gas dearer exceeds the signed paymasterVerificationGasLimit and the EntryPoint reverts the bundle whatever gas the sender gives; 'Operations estimated after activation pass' confirms a re-estimated limit fixes it
- facts.setters include updateVerifyingSigner(address), owner() = 0xddf32240…, a separate key-replace path noted under reading2 but not needed for this root issue
- the gas limit is a field of the signed user operation (EntryPoint mechanism), not a constant in the paymaster's own bytecode

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 26,339 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,174 signature recoveries in the study's two-week trace window.

## Remediation

Bundlers/wallets re-estimate paymasterVerificationGasLimit for the new ecrecover pricing when signing new operations.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-4337-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
