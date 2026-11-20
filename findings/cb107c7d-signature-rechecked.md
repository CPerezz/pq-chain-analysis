---
id: cb107c7d-signature-rechecked
title: "0xcb107c7d: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0xcb107c7d2a93e638b20342f46b10b9b6d81377bf"
  family: "7fc6ab7cd20c1897e94339765ee79749"
  copies: 4
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: bytecode
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
  verdict: refuted
  rating: NONE
  note: "A library has no state or funds of its own; the template link to the LedgerChannel is a misattribution."
---

## Summary

This is a stateless ECTools-style library (3,350 bytes, its own address pushed as the library call guard), not a ledger channel. It holds no channel state and no funds, so nobody relies on a signature here; any loss sits in the channel contracts that link it.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: delegates to a fixed address.
- cast code at 26438999: the bytecode embeds PUSH20 0xcb107c7d… (the Solidity library delegatecall guard)
- selectors 0x1052506f(uint256,bytes,address), 0x1445f713, 0x1dcd9b55, 0x38b025b2, 0x886d3db9, 0xdae21454, 0xdca95419, 0xe9395679: pure helpers, with no storage and no transfer
- no verified source on Sourcify; template 5c6fba46 is LedgerChannel.sol, a different contract

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None here; rate the linked ledger-channel contracts (template 5c6fba46) instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
