---
id: 038b104e-wallets-fixed-signers
title: "0x038b104e (tagged deployed by Polymorph: Deployer): wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x038b104e914a8b64d9d704cabb9c05c0dcf99a4c"
  family: "c63b0c879dde653a862bb6b2f11b07f4"
  label: "deployed by Polymorph: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  note: "An uninitialized implementation/facet: every path to the check is closed, so refuted."
---

## Summary

Not a wallet: a DiamondCutFacet (LimeChain bridge, verified on Sourcify), meant for delegatecall from a diamond. Its own governance storage is empty, so diamondCut can never pass the signature checks at this address.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify exact match: contracts/facets/DiamondCutFacet.sol, whose diamondCut requires n <= membersCount and n > membersCount/2 before LibGovernance.validateSignatures
- Storage at keccak('governance.storage')+0..2 at block 26438999 is all zero: no members, so every call reverts before ecrecover
- Holds no funds (balance 0 at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address. The diamond that delegates to this facet uses its own member set, which LibGovernance updateMember can change; that is a different row if flagged.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
