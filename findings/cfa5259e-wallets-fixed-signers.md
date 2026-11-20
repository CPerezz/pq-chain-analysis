---
id: cfa5259e-wallets-fixed-signers
title: "0xcfa5259e: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xcfa5259e112862ed986dea483d6b1ac530fd0b7b"
  family: "83181953bd1272fe165b260398318003"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owner"
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
  note: "The only direct owner function moves tokens in, not out; spend (ecrecover) is the only exit: HIGH. The pull-from-approver function looks like a drainer pattern."
---

## Summary

A 1-of-1 Ownbit-style spend wallet with an added owner-only 0x354d728d(token,from) that pulls approved tokens INTO the wallet ('freeze'). Funds leave only through spend with an ecrecovered owner signature.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- One SSTORE in runtime code (the spend nonce); no owner setter
- Fork trace: 0x354d728d reverts 'Caller is not an owner' for a stranger; for the owner it calls allowance(from,wallet)/balanceOf(from) and transferFrom into the wallet, so it is not an exit
- spend reaches ecrecover (fork trace); getOwners at block 26438999: 0x11c2..5113 (required 1), an EOA (cast code latest)
- No proxy slots; value $6, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner signs a spend that empties the wallet before the key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
