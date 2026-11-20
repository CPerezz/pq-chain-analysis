---
id: 787ec175-wallets-fixed-signers
title: "0x787ec175: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x787ec175614500fdecf5d22178abccafe0355e4d"
  family: "d6248e847585caf56dcbd3eee36e3007"
  upgradeable: "yes"
  admin: "Nayms diamond owner 0xd5c10a9a09b072506c7f062e4f313af29add9904 (EOA, live)"
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
  note: "Refuted: facet (logic) with no own funds; signer not fixed (per-call stakeholders resolved via ACL), and live diamond owner can upgrade. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Verified Nayms SimplePolicyFacet, the facet currently used by the Nayms diamond. Stakeholder signatures for createSimplePolicy are per-call signers whose entity membership lives in diamond storage managed by Nayms admins; the facet itself holds nothing and the diamond is upgradeable.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan: Verified, contract SimplePolicyFacet (Nayms)
- Nayms diamond 0x39e2f550fef9ee15b459d16bd4b243b04b1f60e5 facetAddress(0x04e2e500) = this address at 26438999
- Diamond owner() = 0xd5c10a9a…9904, EOA nonce 192 (live); diamondCut 0x1f931c1c routed to 0x4726277f…

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address; Nayms admins can reassign entity signers or cut a new facet.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
