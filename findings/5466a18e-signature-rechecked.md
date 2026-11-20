---
id: 5466a18e-signature-rechecked
title: "0x5466a18e: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x5466a18e54c81f9dfe1f40b6ad6550474349af91"
  family: "67828301034dd08326e15fa27eaeeda8"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "Refuted: a pure verification utility with no re-check-after-reliance mechanism and nothing at stake in this contract. Any effect falls on calling contracts, which would be flagged on their own."
---

## Summary

Not a Connext LedgerChannel: a 692-byte stateless ECDSA helper with recover(bytes32,bytes) and verify(address,bytes32,bytes) only. It has no storage, no funds and no relying party; whoever calls it chooses the signer.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: 19045a25 recover returns ecrecover(hash,v,r,s); 1a86b550 verify returns recovered == arg0; no SSTORE, no other functions (selector scan: LOCK8605463013 is a false match)
- Balance 0 and EIP-1967 slots 0 at 26438999; facts: exits [], setters []
- txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
