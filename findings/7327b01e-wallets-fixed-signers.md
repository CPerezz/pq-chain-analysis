---
id: 7327b01e-wallets-fixed-signers
title: "0x7327b01e: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7327b01ef3bce998ca97541ed510ec6e0d96e22b"
  family: "5ad576cdea2aecf32b87967da83a3863"
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
  note: "An uninitialized facet: every path to the check is closed, so refuted."
---

## Summary

Not a wallet: an ERC721PortalFacet of the LimeChain diamond bridge (verified on Sourcify; safeMint is the call to the wrapped token). With zero members and zero precision in its own storage, mintERC721 reverts before ecrecover.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify exact match: ERC721PortalFacet.sol; mintERC721 calls LibGovernance.validateSignaturesLength (members*percentage/precision) then validateSignatures
- keccak('governance.storage')+0..6 all zero at block 26438999: zero members, precision 0 (division by zero reverts)
- No funds (balance 0 at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address; the live diamond's governance manages members.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
