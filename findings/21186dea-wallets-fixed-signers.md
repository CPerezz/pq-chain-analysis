---
id: 21186dea-wallets-fixed-signers
title: "0x21186dea: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x21186dea2b79890170e9d66a785373574f9b9c60"
  family: "4e66b19743acf11a5df87a0aab4b5ff5"
  copies: 2
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
  note: "wrong template match (same Nayms diamond family)"
---

## Summary

Etherscan-verified 'Exact Match' source named 'UtilityFacet' -- another Nayms Diamond facet (setFeeToken + fee/premium-payment functions), not SimpleMultiSig. No execute/getOwners/threshold/ownersArr selectors; 0 reachable ecrecover() calls in the decompile (only leftover 'ECDSA: invalid signature' revert strings from an imported library, never reached by any traced call path).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan Exact Match, Contract Name 'UtilityFacet'
- dispatcher: setFeeToken + 13 unresolved selectors, none matching template 8f5fee6f
- grep -c ecrecover decompiled.sol = 0 (ECDSA revert strings present but no ecrecover() call site found)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
