---
id: erc1155lazypayableclaim-26bbea78-rotate-signer-before-migrating
title: "ERC1155LazyPayableClaim: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x26bbea7803dcac346d5f5f135b57cf2c752a02be"
  family: "f8e75c272300e3a5441b7d8e1d9aff63"
  name: "ERC1155LazyPayableClaim"
  label: "Manifold: ERC1155 Lazy Payable Claim (Extension)"
  upgradeable: "no"
  rating: LOW
  value_usd: 15519
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4418
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "each creator contract's admin"
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
  note: "Per-claim setter callable by each creator's admin. Individual creator admins were not checked; the contract owner is a live Safe."
---

## Summary

Manifold ERC1155LazyPayableClaim: signature-minted claims require recover == claim.signingAddress. A signingAddress with code reverts mints (the study replayed one).

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- LazyPayableClaim.sol:225-231: message.recover(signature) must == signingAddress
- ERC1155LazyPayableClaim.sol:84-112 updateClaim(creatorAdminRequired) rewrites signingAddress per claim
- extension owner() 0x7ef0d682…: Safe, threshold 2, 3 owners

## Impact and exposure

- Value held at block 26,438,999: $15,519 (ETH and 49 priced tokens).
- Activity: 4,418 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

The creator's admin calls updateClaim with a new EOA signingAddress.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
