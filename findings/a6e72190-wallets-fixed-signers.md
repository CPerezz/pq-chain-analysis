---
id: a6e72190-wallets-fixed-signers
title: "0xa6e72190: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xa6e7219077d88d8a3f07e81f72aa76b2f031beef"
  family: "7036816f502b0f2c7202873164685b96"
  copies: 112
  upgradeable: "no"
  rating: HIGH
  value_usd: 515
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $515, txs_90d 0; value does not lower the rating."
---

## Summary

An Ownbit-style ETH wallet (spend, getOwners, getRequired; owners in a mapping): spend needs `required` ecrecovered owners; owners are set only at deployment.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 112 wallets: owners in a mapping; six selectors, none changes owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: spend checks the signature count between required and the owner count and requires each recovered address in the owner mapping; the only runtime SSTORE is the spend nonce (slot 3); no setter, no proxy
- getOwners() at 26438999: 0xeb11de3c… EOA n0, 0xf849a9bb… EOA n0; getRequired() = 2
- Runtime identical to the dossier code.hex

## Impact and exposure

- Value held at block 26,438,999: $515 (ETH and 49 priced tokens, over 112 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
