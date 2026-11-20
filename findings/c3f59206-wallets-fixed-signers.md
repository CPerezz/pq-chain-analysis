---
id: c3f59206-wallets-fixed-signers
title: "0xc3f59206: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xc3f59206d6038dea4c816893825779c37bf27a60"
  family: "35e06906fdd1caedf8e12c46fc96515a"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Diamond facet/implementation, not a wallet. No fixed signer exists at this address → refuted."
---

## Summary

This is not SimpleMultiSig. It is a verified Nayms diamond facet (EntityFacet, solc 0.8.17, src/diamonds/nayms/facets/EntityFacet.sol) whose EIP-712 stakeholder-signature check (createSimplePolicy) runs only through the Nayms diamond's delegatecall and AppStorage. The facet address has no state, no entities and no funds.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan cache: 'Source Code Verified', Contract Name EntityFacet, sources src/diamonds/nayms/{AppStorage,Modifiers,libs/LibEIP712,LibACL,...}.sol; ABI errors incl. DuplicateSignerCreatingSimplePolicy
- Dispatcher selectors 04e2e500,10b4955d,hashTypedDataV4,domainSeparatorV4,a2e4569b,edd2133b,… (no owner/execute/withdraw); ETH balance 0 at 26438999, nonce 1, Etherscan 0 transactions
- Facet logic is gated by diamond ACL storage, which is empty at the facet address. Facets are replaceable by the diamond owner via diamondCut
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. Any signature dependency lives in the Nayms diamond, which its owner can upgrade (diamondCut).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
