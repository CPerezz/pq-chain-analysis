---
id: 005dea29-wallets-fixed-signers
title: "0x005dea29: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x005dea295547ddeae476baa9ef958564f44cca0e"
  family: "ce051c1d510734654727ac2053465fe5"
  copies: 4
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
  note: "wrong template match; this address is not a wallet with fixed signers at all"
---

## Summary

Etherscan-verified source named 'EntityFacet' -- a Diamond facet of the Nayms on-chain insurance marketplace (entity/policy management), not SimpleMultiSig. Zero ecrecover calls anywhere in the decompiled bytecode.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: Source Code Verified, Contract Name 'EntityFacet', compiler v0.8.20
- dispatcher selectors (domainSeparatorV4/hashTypedDataV4 plus 7 unresolved) share nothing with template 8f5fee6f (no execute/getOwners/threshold/ownersArr)
- grep -c ecrecover decompiled.sol = 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
