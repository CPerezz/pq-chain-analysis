---
id: parentstateverifierfacet-391b60c9-signature-rechecked
title: "ParentStateVerifierFacet: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x391b60c9e4bde36bf34eea2c1c0c9af37b3d7bcc"
  family: "9555969c931a2ee2dab541061718624c"
  copies: 7
  name: "ParentStateVerifierFacet"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Uninitialized facet implementation and a loose match to the template; a diamond that uses it has an upgrade path (diamondCut), so even a live use would not be above LOW."
---

## Summary

ParentStateVerifierFacet is not a PaymentChannels copy. It is a diamond facet that checks a percentage of signatures from an authority set (verifierInitialize is guarded by 'LibDiamond: Must be contract owner'). At its own address it is uninitialized: no authorities, sequence 0, holds 0 ETH.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: as its template f37d66cc: PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker…. Template.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile and bytecode strings: getAuthorities, getSequence, verifierInitialize, 569ed7aa, 6df420b9, e626992b; errors 'Invalid sequence', 'Invalid signatures', 'LibDiamond: Must be contract owner'; no template selectors
- cast storage @26438999 on diamond slots 0x7a37bd6f...55b3-b7 all 0; getAuthorities() = [], getSequence() = 0
- EIP-1967 implementation slot 0; balance 0 wei @26438999; txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none at this address; a diamond using this facet can swap it through diamondCut by its owner

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
