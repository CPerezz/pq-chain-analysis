---
id: ledgeroperation-4f7f56d5-signature-rechecked
title: "LedgerOperation: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x4f7f56d57607e346ff8719c9f34cba3bbccae71f"
  family: "0836d446345303d9c11613cd5bab1f3e, 8a260d5c6a185cf6784173051dd05438"
  copies: 2
  name: "LedgerOperation"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 6
  last_active: 2026-11-04
fix:
  layer: new-deployment
  who_acts: "Celer (new ledger deployment) and channel peers (settle before migrating)"
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
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "The receiving peer relied on a co-signed state, and the counterparty's code change alone blocks it from enforcing that state, with no alternative path that keeps the transfers. Payment-channel case = CRITICAL."
---

## Summary

This is the Celer LedgerOperation library, linked as a constant delegate by CelerLedger. intendSettle, snapshotStates and cooperativeSettle need both peers' signatures (_checkCoSignatures) on a simplex state the receiving peer has held and relied on. If the paying peer's address takes real code, the receiver cannot submit the co-signed state. The only one-sig path is the null state (seqNum 0), which settles on deposits and drops the transfers the receiver earned.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Celer LedgerChannel _checkSingleSignature: a peer's signature on channel state, checked when relied on later / Celer LedgerChannel _checkCoSignatures: both peers' signatures on a channel state,…. Read (function text).
- Update path, read at block 26,438,999: no proxy, no upgrade function.
- source/LedgerOperation.sol L1589-1612: _checkCoSignatures requires recover(sig_i) == peerProfiles[i].peerAddr; no code check, no ERC-1271
- L2356-2410 intendSettle: a non-null state needs both co-signatures; a null state needs a single sig and both stored seqNums == 0; confirmSettle pays the stored state after disputeTimeout
- EIP-1967 impl/admin slots are 0 at block 26438999; it is a library with no upgrade function, and the linking ledger calls it at a constant address
- txs_90d 6, last_active 2026-11-04

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 6 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

Peers settle or snapshot their latest co-signed states before migrating a key to real code; Celer deploys a ledger whose signature check accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
