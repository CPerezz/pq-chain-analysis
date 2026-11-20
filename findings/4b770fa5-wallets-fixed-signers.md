---
id: 4b770fa5-wallets-fixed-signers
title: "0x4b770fa5: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x4b770fa51ecd3628c210f6a39853fab3f454c963"
  family: "89e7c630e6ff21fea5d1aca1a1df839e"
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
  note: "Refuted: facet with no own state/funds; signers (governance members) are replaceable by signed updateMember and the diamond is cut-upgradeable. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Verified UtilityFacet of a Teleport (LimeChain) diamond, not a wallet. Its signature checks validate governance-member signatures (setTeleportSenders/setProviderSelector take bytes[] signatures); the member set lives in the diamond and is replaceable via updateMember(address,bool,bytes[]).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: Verified, UtilityFacet (contracts/facets/UtilityFacet.sol, Governable, LibGovernance)
- DiamondCut log at block 19875133 adds this facet to diamond 0xf2d305df14445a0609a44844edc657abadd13473; facetAddress(0x3900d7f5) = this address at 26438999
- Diamond members at 26438999: 3 (0x8464bcb0…ea40, 0x6e5575c5…85f4, 0xc394c47a…6437), all no code (reth, latest); GovernanceFacet exposes updateMember(address,bool,bytes[]) and diamondCut(...,bytes[])

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Members rotate keys through updateMember before migrating to code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
