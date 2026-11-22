---
id: ownbit-0f498806-wallets-fixed-signers
title: "OwnbitMultiSig: wallet with signers fixed in code"
project: ownbit
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0f498806617efa9c5fbd201320d21d43dd47bf00"
  family: "cd492812da255621bb27b42fff2f5b85"
  copies: 66
  name: "OwnbitMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 7539
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2
  last_active: 2026-10-09
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
evidence:
  level: source-read
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $7539, txs_90d 2; value does not lower the rating."
---

## Summary

OwnbitMultiSig (inactivity variant): spend/spendERC20/spendAny need ecrecovered owner signatures. The owners are set only in the constructor; inactivity can lower `required` but never below 1 signature.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig (older variant with inactivity). Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source OwnbitMultiSig.sol: owners set only in the constructor; active() only refreshes ownerBlockMap; getRequiredWithoutInactive() returns at least 1, so _validSignature always needs ≥1 ecrecovered owner
- getOwners() at 26438999: 0x98e5d4dd… EOA, 0xd5f84bc4… 7702 delegation (0xef0100…, still recovers under EIP-8151), 0x78b6b4f3… EOA, 0xef815fb4… EOA; getRequired() = 3
- Runtime code is identical to the dossier code.hex; no proxy slot, no upgrade function

## Impact and exposure

- Value held at block 26,438,999: $7,539 (ETH and 49 priced tokens, over 66 addresses).
- Activity: 2 transactions called it in the 90 days before that block; last on 2026-10-09.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
