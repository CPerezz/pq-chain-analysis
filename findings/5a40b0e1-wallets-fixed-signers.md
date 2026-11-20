---
id: 5a40b0e1-wallets-fixed-signers
title: "0x5a40b0e1: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x5a40b0e1eb3d64ca3e64158ae292b486ee5f2ec0"
  family: "c6867023405ac85e5a1baa2a642944de"
  copies: 3
  upgradeable: "no"
  rating: HIGH
  value_usd: 206
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (1 of 2 EOAs) together with the fixed executor EOA"
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
  note: "Fixed owner set, no other exit; the funds are locked once both owner keys have code: HIGH. This is not the template's exact code (an executor-gated v1 variant). The executor can itself become a contract without harm, since it is only checked as msg.sender."
---

## Summary

A SimpleMultiSig v1 variant: execute 0xf12d394f(v[],r[],s[],dest,value,data) requires msg.sender == a fixed `executor` ('no-permission') and `threshold` (1) signatures from fixed owners ('not-by-owner'). The executor gate is a msg.sender check that EIP-8151 does not touch, but the owner signature still has to recover, and neither owners nor executor can be changed.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: only non-view function 0xf12d394f; require(msg.sender==executor,'no-permission'), require(len==threshold,'number-of-v'/'number-of-sig'), ecrecover then 'not-by-owner'; no setter, no proxy slots
- at block 26438999: threshold=1, nonce=101, owners [0x6835a5d8ee4e6272a60d3a56f8c92522dda116fa, 0xa4dcb88568de764c79ae698867907e47cda798d1], executor 0x61bfa25593d4963130570b44c65150f9db45769c, balance 0.0644 ETH
- cast code latest: both owners EOA (nonce 0); executor EOA (nonce 2364)
- batch row: value_usd 206, txs_90d 0, last_active null, copies 3

## Impact and exposure

- Value held at block 26,438,999: $206 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Executor submits a final execute signed by one owner that moves the funds out, before both owner keys take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
