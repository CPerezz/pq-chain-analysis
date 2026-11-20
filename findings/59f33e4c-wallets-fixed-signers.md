---
id: 59f33e4c-wallets-fixed-signers
title: "0x59f33e4c: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x59f33e4cefeefcc5b28ca18621e0b58682b21388"
  family: "55895d5fa12847af2dbf47b7f5c11066"
  copies: 3
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
  note: "The factory can't re-initialize an existing wallet, so owners can't change after creation; signed spend is the only exit: HIGH."
---

## Summary

A Fintoch Ownbit-style child wallet (2-of-3) with initialize(address[],uint256), callable only by its factory (slot 0 = 0xeab84325…). The factory calls initialize only right after CREATE2 of a new wallet, so owners are fixed once created.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- initialize requires msg.sender == factory ('Fintoch: FORBIDDEN'); slot 0 is never written at runtime; factory 0xeab84325… (latest, unverified) uses selector 0x60b5bb3f only right after CREATE2 at 0x3ec/0x84a on the new address
- Other runtime SSTOREs: the slot-4 nonce in spend/spendERC20/spendAny; fork traces show spendERC20/spendAny reach ecrecover 2 times
- getOwners at block 26438999: 0x083b..a14e, 0x4bbb..e1f4, 0x99af..4d03; required 2; all EOAs (cast code latest)
- No proxy slots; no value measured, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before their keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
