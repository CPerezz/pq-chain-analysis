---
id: liability-0c3d7bea-signature-rechecked
title: "Liability: a signature checked again after others relied on it"
status: confirmed
severity: CRITICAL
patterns: [PQ-15]
impact: funds-locked
contracts:
- address: "0x0c3d7bea3beccc09d0d16743bd67674ad3bb38e8"
  family: "1a185927b65da3bd5209413d075a75f3"
  copies: 51
  name: "Liability"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Robonomics (new factory/liability code); promisors (finalize before migrating)"
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
  note: "The promisee did nothing yet loses the escrow when the promisor's address changes: no update path, no refund = CRITICAL. Rated on the mechanism; this instance holds cost 0. It is a liability, not the factory."
---

## Summary

This is a 49-byte Robonomics liability instance (SharedCode.proxy) that delegatecalls the constant Liability code at 0xebe4a283.... The factory escrows the promisee's `cost` into the liability on creation. finalize() releases it only if the result signature recovers to the promisor recorded from the earlier offer. If the promisor's address takes real code, finalize reverts forever and the promisee's escrow stays locked: there is no timeout or refund.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: Robonomics Liability demand: the promisee's signed demand, checked when the factory builds the liability / Robonomics Liability offer: the promisor's signed offer / Robonomics Liability finalize: the…. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- Factory.sol Liability.finalize: require(recover(sig) == promisor); the transfer of cost to promisor/promisee is the only exit; Factory.createLiability safeTransferFrom(promisee, liability, cost)
- Code 0x6000...73ebe4a283...5af4...: delegate target hardcoded, no proxy slot, no admin
- At block 26438999: promisor 0x6e46c0e4..., promisee 0x008eb1c1..., cost 0, isFinalized false
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 51 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Promisors finalize open liabilities before migrating keys; Robonomics deploys a liability with a timeout refund or ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
