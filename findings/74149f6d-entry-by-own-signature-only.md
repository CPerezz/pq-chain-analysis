---
id: 74149f6d-entry-by-own-signature-only
title: "0x74149f6d (tagged deployed by Earthmeta: Deployer): entry only by one's own signature"
status: confirmed
severity: LOW
patterns: [PQ-21]
impact: liveness
contracts:
- address: "0x74149f6d0dbdbe356fd8035a83dbc0ab7c4c1a8e"
  family: "532c367548d997e832471dbc20b5b27f"
  copies: 2
  label: "deployed by Earthmeta: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 902
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 298
  last_active: 2026-11-18
  recoveries_14d: 25
fix:
  layer: account-migration
  who_acts: "makers (sign listings/offers from an EOA/7702 key)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The signature only authorizes the maker's own offer; nothing held depends on it. LOW holds. Proxy admin role holder not read (RPC timeouts)."
---

## Summary

EarthMeta marketplace implementation (UUPS, run by proxy 0xe15c4cba…): fill/fillWithEmt/acceptOffer/fillFor require the maker's signature over its own listing or offer. Under EIP-8151 a maker with non-7702 code cannot list; credits and NFTs are reached by direct calls.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: orders signed by the user named; an oracle with a setter. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- selectors: fill 0x7efcd986, fillWithEmt 0x717feb53, acceptOffer 0xdb7a88bc, fillFor 0xbd6801d3 (window recoveries: 9 distinct makers, context 0xe15c4cba…); cancelListing/cancelOffer require order.maker == msg.sender (decompile)
- withdraw() 0x3ccfd60b pays credits[msg.sender] in EMT, no signature; no onERC721Received in bytecode, NFTs move maker→taker by transferFrom (no escrow)
- setOracle/setHub/upgradeToAndCall gated by AccessControl roles; implementation storage zero, balance 0 at 26438999 (dossier state)

## Impact and exposure

- Value held at block 26,438,999: $902 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 298 transactions called it in the 90 days before that block; last on 2026-11-18.
- 25 signature recoveries in the study's two-week trace window.

## Remediation

Makers sign from an EOA or 7702-delegated account; nothing to rescue.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
