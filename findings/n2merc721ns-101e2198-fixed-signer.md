---
id: n2merc721ns-101e2198-fixed-signer
title: "N2MERC721NS: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x101e21983a2d812dd5ae80134fe1b314b391ce80"
  family: "3557ce246942e266ef3cf9d0835f0853"
  copies: 19
  name: "N2MERC721NS"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0xe6967ba1973bdeAAAF2601F67E0929deB9Edca8a"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Fee-adjustment function dies but mint keeps an owner fallback and no funds are at risk -> MEDIUM."
---

## Summary

N2M ERC721NS collection: removeProtocolFee requires N2M_SIGNER (constant, no fallback), mintWhitelist accepts N2M_SIGNER or owner(). If N2M_SIGNER gets code, removeProtocolFee (a fee-adjustment call, not a fund release) dies for good, and whitelist minting still works via the owner's own signature. No deposits/escrow are at risk.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: N2M collection: removeProtocolFee needs N2M_SIGNER (fixed in the code); the owner can also sign mints; no funds held, a fee function stops (MEDIUM). Read.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Common.sol:296-312: removeProtocolFee requires signer==N2M_SIGNER only; NSMinting.sol:401,416: mintWhitelist accepts signer==N2M_SIGNER
- signer==owner() (dossier source)
- Storage.sol:93: N2M_SIGNER constant 0x00000000156D54b85de04c897356026a5ff2cBc9, no setter
- N2M_SIGNER code check: eth_getCode returns 0x (EOA) at latest block ~0x193a3c9 (publicnode; this is an immutable constant, can't have changed since the pinned block)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 19 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

N2M redeploys the collection or routes fee removal through the owner instead.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
