---
id: c12f0a46-wallets-fixed-signers
title: "0xc12f0a46: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc12f0a46369d29b9514375dbedc96d174030323e"
  family: "8b6d3b8c361d5b9fd1cffe8ecf061e98"
  copies: 6
  upgradeable: "no"
  rating: HIGH
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-11-04
  recoveries_14d: 1
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

A 45-byte EIP-1167 clone of BitGo WalletSimple 0.8 (impl 0x944fef03…, fixed), initialised with 3 signers. Spending needs a signer caller plus one ecrecovered co-signer.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo pattern (signers, sendMultiSig) by its names. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Code = minimal proxy to 0x944fef03… (no admin, no upgrade); impl selectors include init c6044c46, sendMultiSig 39125215, onlySigner modifier, no 1626ba7e
- Creation tx 0x2147bbe7… via factory 0x809ee567…: createWallet(signers 6add7d…, 4205c3…, 1805949f…); clone slot1 = initialized; signers(addr)=true (latest)
- Signers 0x6add7d2c06f0ec96b46c98c639105a3b6dd0b482, 0x4205c3490e177bc2c1aaaa77ba285eea878b7d7e, 0x1805949fa705053dc2ae09d31c5b32ddd66742d6: all EOAs, no code (latest, block ~26452917); value_usd 1, txs_90d 3, last_active 2026-11-04 (row)

## Impact and exposure

- Value held at block 26,438,999: $1 (ETH and 49 priced tokens, over 6 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-04.
- 1 signature recoveries in the study's two-week trace window.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
