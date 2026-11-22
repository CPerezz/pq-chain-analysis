---
id: bridge-17d6e670-rotate-signer-before-migrating
title: "Bridge: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x17d6e670ee8ef8464cafc098bf20668987012330"
  family: "f33690206e531da20de1a85a04370bfd"
  copies: 2
  name: "Bridge"
  label: "The Open Network: TONCOIN Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 441
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 20953
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "oracle set (2/3)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The key holders (9 EOA oracles) can rotate the set themselves."
---

## Summary

TON Bridge (wrapped TON); minting and burn switches need signatures from at least 2/3 of the oracle set. Under EIP-8151 a signer that takes non-delegation code stops recovering, so this path stops until the key is rotated.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Bridge: minting and burn switches need oracle-set signatures; voteForNewOracleSet replaces the set. Read.
- Bridge.sol: voteForNewOracleSet replaces the set when ≥2/3 of current oracles sign
- getFullOracleSet() at block 26438999 = 9 addresses, all without code (nonce 0, off-chain signers)

## Impact and exposure

- Value held at block 26,438,999: $441 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 20,953 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

Oracles sign a new set before any of them takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
