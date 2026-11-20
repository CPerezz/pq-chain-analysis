---
id: pwnloan-c58791ec-signed-shortcut-lost
title: "PWNLoan: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc58791ec351349a82036ae712976109c10e34217"
  family: "6f0c7eab1502c659da764198bf7b3e36"
  name: "PWNLoan"
  upgradeable: "no"
  rating: NONE
  value_usd: 211494
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-10
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "The code checks for code before calling ecrecover, so an address with code is handled: refuted."
---

## Summary

PWN loan: proposals are accepted by the proposer's on-chain call or by signature through PWNSignatureChecker. That library checks signer.code.length > 0 first and then uses ERC-1271, so a signer with code never reaches ecrecover.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: a proposal made acceptable on chain by its proposer, or a signature checked by ECDSA or ERC-1271. Read from source.
- source/src/core/lib/PWNSignatureChecker.sol:36 if (signer.code.length > 0) -> IERC1271.isValidSignature staticcall
- PWNProposalManager.sol:62 makeProposalAcceptable gives an on-chain path for the proposer as well
- isValidSignature 0x1626ba7e present in runtime code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $211,494 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

None needed; a proposer with code signs by ERC-1271 or makes the proposal acceptable on chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
