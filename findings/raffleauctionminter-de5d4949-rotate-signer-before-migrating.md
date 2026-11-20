---
id: raffleauctionminter-de5d4949-rotate-signer-before-migrating
title: "RaffleAuctionMinter: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xde5d4949f445650325c7c8739610c3a979c7a6db"
  family: "a14ad682161f53a4a3b6ecfb5929be72"
  name: "RaffleAuctionMinter"
  label: "deployed by Persona: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 24903
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 13
  last_active: 2026-11-14
fix:
  layer: onchain-config
  who_acts: "DEFAULT_ADMIN_ROLE holder (not enumerated)"
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
  note: "The signed function is already closed and refunds/claims are direct; the admin holder was not enumerated."
---

## Summary

RaffleAuctionMinter: placeBid requires a signature from gateway.nftManager(nft); claims and refunds are unsigned.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: AuctionMinter: signed by the signer its caller passes, a role holder. Read from source.
- setGateway is onlyRole(DEFAULT_ADMIN_ROLE) (RaffleAuctionMinter.sol:76); gateway 0x7127…26A9 is a contract
- auctionEndTime = 1708646460 (Feb 2024), so placeBid is already closed; claimAndRefund needs no signature

## Impact and exposure

- Value held at block 26,438,999: $24,903 (ETH and 49 priced tokens).
- Activity: 13 transactions called it in the 90 days before that block; last on 2026-11-14.

## Remediation

None needed now. For new auctions, rotate nftManager on the gateway or setGateway.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
