---
id: 7db0dc65-wallets-fixed-signers
title: "0x7db0dc65: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7db0dc65dfd8cd6aa5100418dd7da38aac786123"
  family: "07346f3982dd06367803d2187cb6df6f"
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
  note: "An uninitialized facet, so refuted."
---

## Summary

Not a wallet: a FeeExternalFacet of the LimeChain diamond bridge (verified on Sourcify). setExternalFee/setExternalFeeAddress need onlyValidSignatures against an empty member set at this address, so they always revert.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify exact match: FeeExternalFacet.sol; both setters use onlyValidSignatures (n <= members, n > members/2) and validateSignatures
- keccak('governance.storage')+0..6 all zero at block 26438999
- No funds (balance 0 at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
