---
id: 83f667d6-signature-rechecked
title: "0x83f667d6: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x83f667d63dacebacccb11f8082bfead6c0986b2e"
  family: "b61efd963a0b573e0847c6bdef4c99a4"
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
  note: "A pure library holds nothing and acts on nothing. Any loss sits in the caller's logic, not here."
---

## Summary

Not a Connext ledger channel: a 918-byte stateless signature helper (verifySignature(bytes32,bytes,address), recoverSigner(bytes32,bytes), recoverSigner2(bytes32,uint8,bytes32,bytes32)). It has no storage, no funds and no relying party.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template 5c6fba46: Connext ledger channel ECTools.isSignedBy: true when the recovered address equals the one named / Connext ledger channel consensus close: both parties of the channel must…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- cast selectors: 0x31cd4199 verifySignature, 0x97aba7f9 recoverSigner, 0xbdb33d48 recoverSigner2; none in common with template 5c6fba46
- heimdall: pure functions only, returning ecrecover(...) or arg2 == recovered; no SSTORE, no transfers
- balance 0 at 26438999; EIP-1967 slots 0; txs_90d=0, last_active=null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none for this address; any caller relying on it is rated on its own

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
