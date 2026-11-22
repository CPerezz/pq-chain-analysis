---
id: erc721lazypayableclaim-23aa05a2-rotate-signer-before-migrating
title: "ERC721LazyPayableClaim: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x23aa05a271debffaa3d75739af5581f744b326e4"
  family: "1af97a7afba443451e828356101e4621"
  name: "ERC721LazyPayableClaim"
  upgradeable: "no"
  rating: LOW
  value_usd: 4150
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1108
  last_active: 2026-11-17
  recoveries_14d: 6
fix:
  layer: onchain-config
  who_acts: "each creator (claim admin)"
evidence:
  level: source-read
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
  note: "Per-claim setter held by each creator. [INFERENCE] updateClaim is creator-admin gated (standard Manifold, not traced line by line)."
---

## Summary

Manifold ERC721LazyPayableClaim: signature-gated claims check the per-claim signingAddress. A signer with code makes those mints revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- LazyPayableClaim.sol:230 signer = message.recover(signature); signer != signingAddress reverts
- signingAddress is part of the claim params that creators set via initializeClaim/updateClaim (exits list)
- Extension owner() = 0x7eF0d682… is a Safe, 2 of 3 owners

## Impact and exposure

- Value held at block 26,438,999: $4,150 (ETH and 49 priced tokens).
- Activity: 1,108 transactions called it in the 90 days before that block; last on 2026-11-17.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

The creator updates the claim with a new signingAddress without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
