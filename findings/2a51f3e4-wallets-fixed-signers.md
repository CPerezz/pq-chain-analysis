---
id: 2a51f3e4-wallets-fixed-signers
title: "0x2a51f3e4: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2a51f3e46e3cce59fc50d3adc96af5e5a0ddc510"
  family: "8d0074db7056d824c2d26954d21075e2"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owners"
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
  note: "Role functions act on other contracts and are signed; owners fixed; no unsigned exit: HIGH."
---

## Summary

An extended Ownbit multisig (3-of-4) with spend, spendERC20, spendAny and three more signed 6-argument functions (0x380eb9cf, 0x3bee9e57, 0x5c0ef14e). Those three call grantRole/revokeRole/mint on external contracts; none changes this wallet's owners.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Six runtime SSTOREs, all the slot-3 nonce increment (one per signed function); grantRole/revokeRole/mint appear only as outbound call selectors, not in the dispatcher
- Fork traces with 3 signatures: 0x380eb9cf, 0x3bee9e57, 0x5c0ef14e, spendERC20 and spendAny each reach ecrecover 3 times
- getOwners at block 26438999: 0x997a..ebfc1, 0x7d6d..b068, 0x0f3f..9ee3, 0x58ee..594a; required 3; all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before their keys gain code (also re-point any external roles it holds).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
