---
id: wallet-6c5e91e9-rotate-signer-before-migrating
title: "Wallet: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6c5e91e9b4d1799ea48a4de216184bff7ef32676"
  family: "19940b45c506308c5fb65a18d2d9321b"
  copies: 17229
  name: "Wallet"
  upgradeable: "yes"
  rating: LOW
  value_usd: 221420
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner EOA"
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
  note: "Setter closed, but owner keeps a direct path for all acts."
---

## Summary

TokenCard Wallet (17,229 proxies): controller relays owner-signed txs; ERC-1271 by owner.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the owner of the contract. Read from source.
- transferOwnership needs _isTransferable: isTransferable()=false at block, so no rotation
- owner 0x96e499c2…bcd8 EOA nonce 2; transfer/executeTransaction/bulkTransfer are onlyOwnerOrSelf (wallet.sol:784,836,581)

## Impact and exposure

- Value held at block 26,438,999: $221,420 (ETH and 49 priced tokens, over 17,229 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner acts by direct call.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
