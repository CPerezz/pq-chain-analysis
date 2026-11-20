---
id: trezormultisig2of3-05aa241f-wallets-fixed-signers
title: "TrezorMultiSig2of3: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x05aa241faebac082d03528e2045152caf44a9776"
  family: "c5fe9276b4ebca26d0139393e7e708d9"
  copies: 54
  name: "TrezorMultiSig2of3"
  upgradeable: "no"
  rating: HIGH
  value_usd: 217
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

TrezorMultiSig2of3: spend needs two distinct ecrecovered owners out of three fixed in the constructor. There is no other outflow.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: TrezorMultiSig2of3 _validSignature: two distinct owners of three fixed at deployment. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dossier source TrezorMultiSig2of3.sol: owners mapping written only in the constructor; spend -> _validSignature (2x ecrecover) -> _distinctOwners
- Runtime selectors: spend, generateMessageToSign, spendNonce, the two version getters only; the facts' "withdrawAirdrop" exit is absent
- Constructor args (creation tx 0x0d96612a…, block 5574579): owners 836e58…, b127b6…, b0342e…
- Signers 0x836e58c7aafcc28ba2d495a4d93ee7a06cd7452b, 0xb127b6890d965c3a6f3c0db9018fcfcd1dbb66ae, 0xb0342e7bdde453aabe94194a7e88012b58559cfa: all EOAs, no code (latest, block ~26452917); value_usd 217, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $217 (ETH and 49 priced tokens, over 54 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
