---
id: fastexithandler-07658107-signature-rechecked
title: "FastExitHandler: a signature checked again after others relied on it"
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x07658107cf02559a307cca6f2e63991387d479c3"
  family: "5d39d3089e7eca478a95e7d6b9d3d7f9"
  copies: 2
  name: "FastExitHandler"
  upgradeable: "yes"
  admin: "Proxy admin MinGov 0x17bcf59d… (7-day proposal delay), owned by 2-of-3 MultiSigWallet 0xC5cDcD5470AEf35fC33BDDff3f8eCeC027F95B1d"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "Leap governance (2-of-3 MultiSigWallet 0xC5cD… via MinGov 0x17bc…, 7-day delay)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A live admin upgrade path drops it to LOW (the implementation sits behind a live proxy)."
---

## Summary

This is the current implementation of Leap's exit-handler proxy 0x495AeB6F… (exitDuration 151200). challengeExit proves a spend with the exit owner's earlier signature; if that owner's address takes code, a fraudulent exit can no longer be challenged. The proxy's admin is live governance, so an upgrade fixes it.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Leap FastExitHandler challengeExit: an exit is challenged with a spending transaction its owner signed earlier. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- zos implementation slot 0x7050c9e0… of proxy 0x495AeB6F… at 26438999 = 0x07658107…; admin slot 0x10d6a54a… = 0x17bcf59d… (MinGov-style, proposalTime 604800)
- MinGov owner() = 0xC5cDcD54… MultiSigWallet, required()=2 of 3 owners; owner 0x8db6B632… nonce 3061 (7702-delegated) and 0x5B4dF17C… nonce 705 are live
- Sourcify verified source (scratch review_agents/036/src) FastExitHandler.sol challengeExit: signer = ecrecover(...) compared with the exit owner; no code or 1271 check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Governance upgrades the exit handler to accept ERC-1271/code-aware spend proofs.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
