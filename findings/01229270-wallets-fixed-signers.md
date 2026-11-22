---
id: 01229270-wallets-fixed-signers
title: "0x01229270: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x01229270e0ccc1c1236771f47d870cd8119f0b13"
  family: "e88954c08b1625b835d05037d66911d2"
  upgradeable: "no"
  rating: HIGH
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
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
  note: "Fixed owners; signed spend is the only exit: HIGH. With 3-of-3, one owner's key gaining code is enough to freeze the wallet."
---

## Summary

An Ownbit-style 3-of-3 multisig: spend(address,uint256,uint8[],bytes32[],bytes32[],bytes) with ecrecover, plus ERC-721/1155 receivers and CHAINID. No owner setter.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: spend, getOwners, getRequired, getSpendNonce, MAX_OWNER_COUNT, CHAINID, onERC721/1155Received; one SSTORE (nonce)
- Fork trace: spend reaches ecrecover 3 times with 3 signatures
- getOwners at block 26438999: 0xe85e..ce95, 0xf7ea..6395, 0xdc6c..4f5b; required 3; all EOAs (cast code latest)
- No proxy slots; value $2, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend to a new wallet with replaceable signers before any key gains code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
