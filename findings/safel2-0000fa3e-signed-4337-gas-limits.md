---
id: safel2-0000fa3e-signed-4337-gas-limits
title: "SafeL2: signed ERC-4337 verification gas too small"
status: confirmed
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- address: "0x0000fa3e509d629516ae56dc6fdd31047300114d"
  family: "cbf21f99097a2b70e5ebbaf5001dde0a"
  copies: 928
  name: "SafeL2"
  label: "deployed by Pimlico: ERC-4337 Bundler 12"
  upgradeable: "yes"
  rating: LOW
  value_usd: 228818
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3744
  last_active: 2026-11-17
  recoveries_14d: 339
fix:
  layer: offchain
  who_acts: "bundlers/wallet software estimating gas after EIP-8151 activates"
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
  note: "Matches the root issue exactly: a real failure at the old signed limit, confirmed passing when more gas is signed in. LOW by nature."
---

## Summary

A Pimlico-deployed SafeL2 account (928 copies) used in ERC-4337 bundles: validateUserOp checks the owner's Safe signature and a separate paymaster checks its own signature, each under a verificationGasLimit signed into the user operation itself, not hard-coded in the Safe's code.

## Mechanism

PQ-18. The verification gas limit is signed into the operation, so only a new signature with a higher limit helps.

## Evidence

- How it was placed: traced: an ERC-4337 bundle (EntryPoint 0x0000000071727de2…); a Safe account's owner signatures are checked in validateUserOp and a paymaster checks its own, each under a verification gas limit signed…. Executed and traced.
- row study reading1 (traced): with two cold recoveries 6,200 gas dearer, the signed verification gas limit is exceeded and the bundle reverts whatever gas the sender/bundler supplies — a real failure under the old, too-tight signed limit
- same reading: 'Operations estimated after activation pass' — a replay with a limit re-estimated for EIP-8151's cost confirms the fix is simply budgeting more gas, not a contract change
- facts.getters show only masterCopy(); no fixed-gas constant anywhere in this Safe account's own code — the limit lives in the signed userOp/EntryPoint, matching eip-8151-signed-4337-gas-limits rather than eip-8151-fixed-signer-gas-recovery

## Impact and exposure

- Value held at block 26,438,999: $228,818 (ETH and 49 priced tokens, over 928 addresses).
- Activity: 3,744 transactions called it in the 90 days before that block; last on 2026-11-17.
- 339 signature recoveries in the study's two-week trace window.

## Remediation

Bundlers and wallets re-estimate verificationGasLimit/paymasterVerificationGasLimit for the new ecrecover pricing when signing new user operations; already-signed stale operations simply need resubmission with a bigger limit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-4337-gas-limits` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
