---
id: d951f225-wallets-fixed-signers
title: "0xd951f225: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xd951f22596fa1a9400fd831395c0824c4bc6cbc4"
  family: "f43909e6ae06d38119b8bcf940e2f3a9"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the single owner 0x028ce979… (move funds out before giving the key code)"
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
  note: "Fixed owner set, no setter, no upgrade, no other exit → owner's funds locked if the key migrates → HIGH."
---

## Summary

This is a SimpleMultiSig v2 copy (EIP-712, execute 0xa0ab9653 with executor/gasLimit, extra no-arg constant getters) with a 1-of-1 owner fixed at construction. The only way to move its ETH/tokens is execute signed by that owner.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: execute a0ab9653, isOwner, threshold, nonce, getOwners, DOMAIN_SEPARATOR + 7 no-arg view getters (constant type strings/hashes); strings 'SIGNERS MUST BE IN INCREASING ORDER','FAILED TO RECOVER SIGNATURES'; the only runtime SSTORE is the nonce increment; no proxy (1967 slots zero)
- At 26438999: threshold=1, getOwners=[0x028ce9793123344cde592f393b96a8368c1b0abb] (EOA, no code, nonce 22), nonce=2
- ETH balance 41999999999798 wei (~0.000042 ETH) at 26438999; Etherscan 3 transactions
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner moves the funds out with a signed execute before its key gets code. Otherwise the funds are locked.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
