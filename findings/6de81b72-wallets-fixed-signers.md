---
id: 6de81b72-wallets-fixed-signers
title: "0x6de81b72: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x6de81b72017af333219d220e959c6e460a4821a6"
  family: "fb978013a5da084f0c2b7309a21e6f6a"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "Teleport governance members (signed updateMember)"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: logic facet; governance signer set is replaceable, diamond upgradeable through signed diamondCut. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Verified TeleportFacet of the same Teleport diamond (transmit/deliver/onProviderReceive; fee setters gated by member signatures). Signer set = diamond governance members, replaceable via updateMember; facet holds nothing.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: Verified, TeleportFacet (LibGovernance, Governable)
- DiamondCut log at block 19870645 adds it to diamond 0xf2d305df14445a0609a44844edc657abadd13473; facetAddress(0x55153558) = this address at 26438999
- Diamond: 3 members (all EOAs, no code), updateMember(address,bool,bytes[]) present; diamond balance 1.5118 ETH at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Members rotate keys through updateMember before migrating to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
