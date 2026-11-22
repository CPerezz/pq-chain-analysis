---
id: fa53fd95-wallets-fixed-signers
title: "0xfa53fd95: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xfa53fd95cc839363e8aacbd205ce39509be0ef0f"
  family: "37e160756bfaa553809076bf07f22063"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "none (no setter); owners must move funds out before any owner's EOA takes code"
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
  note: "fixed 3-owner/2-threshold wallet, no update path, no other exit -> HIGH regardless of the $1 balance"
---

## Summary

SimpleMultiSig v2.0.1 exact copy (execute w/ executor+gasLimit variant); 3 fixed owners checked in strictly ascending order via ecrecover, threshold=2, no setter, no proxy. Row value $1 held, 0 txs/90d, dormant.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher selectors exact match template 8f5fee6f: execute/getOwners/isOwner/threshold/nonce/SALT/NAME_HASH/VERSION_HASH/TXTYPE_HASH/EIP712DOMAINTYPE_HASH/DOMAIN_SEPARATOR
- getOwners()=[0x354bf419e0b910cb0e79e55c097bf9d41b0b88d4,0x4c9950b2cdf6c462f305a8758a7582d92afbfdf4,0x91e6adeb41f1dcc5330ba19c34d4a632cddc45c1], threshold()=2 (scanner read, block 26438999)
- eth_getCode on publicnode (latest, block ~26488250) for all 3 owners = 0x (EOA)
- no setter/upgrade selector in dispatcher; no EIP-1967 impl/admin slot set

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owners must move funds to a new wallet before any two of them take code (e.g. via 7702 delegation)

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
