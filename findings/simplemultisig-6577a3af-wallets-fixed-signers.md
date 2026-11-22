---
id: simplemultisig-6577a3af-wallets-fixed-signers
title: "SimpleMultiSig: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x6577a3af5e29d9a08f7b754d75453d4f6a87e664"
  family: "17da11332b2149830ead5d7e5bfba69a"
  copies: 11
  name: "SimpleMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 113
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

SimpleMultiSig (solc 0.4, 2 of 3 owners) whose owners are set at deployment. Every execute needs 2 ecrecovered owner signatures.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig execute: threshold owners, set at deployment; no function changes them. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source (recovered by EthereumHistory): SimpleMultiSig execute: threshold signatures recovered by ecrecover, strictly increasing, each isOwner; owners set only in the constructor
- threshold()=2, ownersArr = 3 owners (latest); code 1736 bytes, no proxy slot
- Signers 0x33F470Ab13F868e324DCdD37f20d6636F62E71B7, 0x423dAD5D31C8655ba3aca59eFD9bdB6A25d0Ab7d, 0xc7db6954E0Ea777A06d1787ED11274Da9b4005d9: all EOAs, no code (latest, block ~26452917); value_usd 113, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $113 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
