---
id: interchaingaspaymaster-0bad2e52-rotate-signer-before-migrating
title: "InterchainGasPaymaster: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0bad2e5210a31716a922b8f71badcccde3e0a791"
  family: "0736d8d5ddb5f8e186b3d5ba44d863f5"
  copies: 11
  name: "InterchainGasPaymaster"
  label: "Hyperlane: Interchain Gas Paymaster"
  upgradeable: "yes"
  rating: LOW
  value_usd: 57
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 46818
  last_active: 2026-11-18
fix:
  layer: onchain-config
  who_acts: "owner 0x0e31…aff0"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "stored-key setter callable by a live EOA owner"
---

## Summary

Hyperlane InterchainGasPaymaster: signed quotes from quote signers kept in storage.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is a set of keys kept in storage; functions replace it (addQuoteSigner, removeQuoteSigner, setDestinationGasConfigs, setTokenGasOracles). Whoever holds it must replace it before that…. Rule: stored-key.
- addQuoteSigner/removeQuoteSigner are onlyOwner in decompile
- owner() = 0x0e317b42b4479925a5b9336bc26211376fb9aff0 at block 26438999; EOA, nonce 71

## Impact and exposure

- Value held at block 26,438,999: $57 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 46,818 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

owner swaps the quote signer for a fresh EOA

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
