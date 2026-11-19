---
id: eip-8151-signed-4337-gas-limits
title: "ERC-4337 operations whose signed verification gas is too small for EIP-8151's price"
status: candidate
severity: LOW
patterns: [PQ-18]
impact: liveness
contracts:
- {address: "0x0000fa3e509d629516ae56dc6fdd31047300114d", family: "cbf21f99097a2b70e5ebbaf5001dde0a", copies: 928, name: "SafeL2", label: "deployed by Pimlico: ERC-4337 Bundler 12", upgradeable: "yes", rating: LOW, value_usd: 228818, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 339, note: "traced: an ERC-4337 bundle (EntryPoint 0x0000000071727de2…); a Safe account's owner signatures are checked in validateUserOp and a paymaster checks its own, each under a verification gas limit signed…. Executed and traced."}
- {address: "0x000000000804ff442be7d200445362c46a008add", family: "f441c4cb49a72abfcfc0ccbd58df3d5d", copies: 3, upgradeable: "yes", rating: LOW, recoveries_14d: 1174, note: "traced: an ERC-4337 bundle; this verifying paymaster is called by the EntryPoint with the paymaster verification gas limit of each user operation (30,000), which is signed in the operation. With the…. Executed and traced."}
evidence: {level: source-read, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, signed ERC-4337 budget"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
reviews: []
---

## Summary

A real operation of each family fails under EIP-8151 even with more transaction gas. 2 code families, 931 addresses, $229k held, 1,513 recoveries in the study's two-week window. Rows by rating: LOW 2. 0 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-18. The verification gas limit is signed into the operation, so only a new signature with a higher limit helps.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0x0000fa3e509d629516ae56dc6fdd31047300114d` (SafeL2): $229k, LOW, 928 addresses

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Wallets sign operations with a higher verification limit.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
