---
id: c72c7574-wallets-fixed-signers
title: "0xc72c7574: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc72c757471c17d874fe9632bcdea24028968336b"
  family: "90ae04a03c6c33dcaf2a9e9e960df81a"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the owner moves the funds to a new account while its key is still an EOA"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "Same account logic as 0x999408fd: only owner-signed meta-transactions move funds, the owner is fixed and there is no direct call, so anything held would lock once the owner key's account has code. Value never lowers the rating: HIGH."
---

## Summary

Not a Gemini custodian. EIP-1167 clone of 0x92085d7d, the same ProxyAccount logic as 0x55b6be9e (same revert strings and selectors, nearly the same size). Only meta-transactions signed by the fixed owner run; there is no owner setter and no upgrade.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: delegates to a fixed address.
- cast code: EIP-1167 -> 0x92085d7d57c9a261cda2b0d4f016eb050d89f8d7
- impl strings: 'Owner did not sign this meta-transaction', 'Owner is already set'; CALLER only in metadata
- owner()=0x62432f56...f89b (EOA, nonce 4); ETH balance 0 (tokens not checked)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner moves the proxy's assets out with an owner-signed forward() before the owner address gets non-delegation code; nothing can be changed afterwards.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: the review found that root issue `eip-8151-wallets-fixed-signers` applies, not `eip-8151-fixed-signer`; filed under it.
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
