---
id: b96b4c37-wallets-fixed-signers
title: "0xb96b4c37: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xb96b4c37ea1b11ca02397206100f0501f975a326"
  family: "8e2c4bdf12239804529abf9a958a4ef3"
  upgradeable: "no"
  rating: HIGH
  value_usd: 240
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
  note: "Fixed owner mapping, no setter or upgrade, a signed transfer is the only way out: HIGH."
---

## Summary

Not Ownbit: an unverified 2-of-2 multisig with tranCoin(address,address,uint256,bytes32[],bytes32[],uint8[]), isOwner and nonce. Owners are set in the constructor only, and tranCoin (ecrecover) is the only exit.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Dispatcher: only tranCoin (0x22023bd7), isOwner, nonce; one SSTORE in runtime code (the nonce increment)
- Creation tx 0x20b21fa3… (Blockscout): owners [0xe49d13fc…beab0, 0xb8388584…4a2c], required 2; isOwner true for both (latest, block ~26452900)
- Both signers are EOAs (latest via publicnode, block ~26452900); nonce slot 3 = 174, so it has been used
- No proxy slots; row value $240 (0.002 ETH held), 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $240 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the tokens and ETH out with tranCoin before either key gains code; a new multisig with replaceable signers.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
