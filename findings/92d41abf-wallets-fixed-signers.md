---
id: 92d41abf-wallets-fixed-signers
title: "0x92d41abf: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x92d41abfed94a7d77a5758e53b8d2e58970644b0"
  family: "313bbcbf9be67e3665ff12f79419e81d"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
evidence:
  level: bytecode
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
  note: "Facet/implementation, no own funds or signers → refuted."
---

## Summary

Not SimpleMultiSig: verified Nayms EntityFacet, a diamond facet (implementation) with no state of its own; it is not the facet the Nayms diamond currently routes to.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: verified 'EntityFacet'; selectors createSimplePolicy/startTokenSale/updateEntity/enableEntityTokenization (sels.txt, 4byte)
- Nayms diamond 0x39e2…60e5 facetAddress(createSimplePolicy 0x04e2e500) = 0x787E…5e4D, not this address (latest) (settable diamond state, latest, block ~26452900, publicnode; not decisive: refutation rests on the facet holding no state)
- ETH 0, nonce 1; signer checks run in the diamond's storage context, diamond upgradable by Nayms governance
- row: value_usd null, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
