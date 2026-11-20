---
id: 518b7df8-wallets-fixed-signers
title: "0x518b7df8 (tagged deployed by Polymorph: Deployer): wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x518b7df876f08d1848390cf5d54d99f29c170e50"
  family: "b6740f7e397c71662a1ca9e954e9f120"
  copies: 2
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
  note: "An uninitialized facet: no path reaches a successful ecrecover, so refuted."
---

## Summary

Not a wallet: a FeeCalculatorFacet of the LimeChain diamond bridge (verified on Sourcify). At this address the governance member set is empty, so setServiceFee can never pass onlyValidSignatures and claim() (onlyMember) can't be called by anyone.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Sourcify exact match: FeeCalculatorFacet.sol; setServiceFee uses onlyValidSignatures (n <= members and n > members/2) then LibGovernance.validateSignatures
- keccak('governance.storage')+0..6 all zero at block 26438999: zero members
- No funds held (balance 0 at block 26438999)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None at this address; the live diamond's governance can replace members.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
