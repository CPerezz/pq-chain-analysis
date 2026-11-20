---
id: 7410dc72-own-signature-only-exit
title: "0x7410dc72: funds released only by the party's own signature"
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: liveness
contracts:
- address: "0x7410dc72ea112a7b09e9380fd602836370cfe031"
  family: "3936b80dd9e3e56be5d3ee4e6b5cbcf1"
  upgradeable: "yes"
  admin: "0xb16283a233d5b010a7b290d593847207495f0284"
  rating: LOW
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "Panther diamond owner (Safe 0xb162..0284)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Only a function stops, and a live diamondCut owner can fix it -> LOW (contradicts the row's 'no update path')."
---

## Summary

Panther ZAccountsRegistry facet: registerZAccount records the address recovered from the registration signature as the zAccount's master EOA. An account with code can never register as a master; already-registered zAccounts are not re-checked. Nothing is locked. The facet runs inside Panther diamond 0x5335..e16c, which can swap it out.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: Panther zAccount registration: the zAccount's master EOA is whatever address the registration signature recovers to (no ERC-1271, the caller does not count). An account with code can never be…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode selectors: registerZAccount 0xcd14c8b1, activateZAccount 0xccf859e0, masterEOAs(uint24); txs.json shows all 3 window calls via context 0x5335839b374e6b2c8b9f0b4930e7eae3192ce16c
- Diamond 0x5335..: facetAddress(0xcd14c8b1)=0x7410dc72...; diamondCut 0x1f931c1c is on facet 0xDD1f..9046, gated by msg.sender == store at slot 0x727bf4..8d44
- That slot holds 0xb16283a233d5b010a7b290d593847207495f0284, a contract with getThreshold()=2 (Safe) at block 26438999
- Row says upgradeable=no for the facet address; the live context is upgradeable via diamondCut

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Panther's owner Safe can cut in a facet that accepts ERC-1271 or 7702; meanwhile code-bearing users register with an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
