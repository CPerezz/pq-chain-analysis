---
id: 0aa8799e-wallets-fixed-signers
title: "0x0aa8799e: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0aa8799e517c6f95771ae455f8bfed41b0146567"
  family: "1962edbaa1555910e20f3a308bd9b75b"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "execute() can only be submitted by the designated executor() address, but every signature must still recover to one of the 3 fixed owners (isOwner), threshold 2-of-3; no setter for owners or executor"
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
  note: "executor restriction doesn't change who must sign; HIGH as a fixed 3-owner/2-threshold wallet"
---

## Summary

SimpleMultiSig 'executor' variant (adds tokenFallback + an executor-only submission gate); 3 fixed owners, threshold 2-of-3, all EOAs today. executor() currently reads 0x...03, a non-standard placeholder, and in any case only restricts who may relay an already-signed tx -- it is not a signature-free exit.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- dispatcher: isOwner/threshold/ownersArr/nonce/executor/tokenFallback/0xfeae6b39(execute-with-executor-arg)/0xc0ee0b8a
- ownersArr(0..2) via publicnode = 0x0f6ab7482762c5de53ae09764c858adab025ac8c,0x141ee13cd17188d55878207c0815eed575fe31b4,0x20c31ba0e7b080794798e49433cbd6e624468491
- threshold()=2 (scanner read, block 26438999)
- executor() = 0x0000000000000000000000000000000000000003 (publicnode eth_call, latest)
- eth_getCode on publicnode (latest, block ~26488250) for all 3 owners = 0x (EOA)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

owners must migrate before two of the three owners take code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
