---
id: kubzwaitlist-7eeeadaf-rotate-signer-before-migrating
title: "KubzWaitlist: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7eeeadafb417d9627c49dbe91a4e0e48f167a536"
  family: "497cdea396272d552ba5b03783a1501c"
  copies: 2
  name: "KubzWaitlist"
  label: "deployed by Kubz: Deployer"
  upgradeable: "yes"
  rating: LOW
  value_usd: 14436
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6c8ee01f1f8b62e987b3d18f6f28b22a0ada755f"
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
  note: "LOW: setter callable by a live EOA owner, and the proxy is upgradeable too."
---

## Summary

Kubz waitlist refund (upgradeable proxy): refund(bytes) needs ECDSA.recover == opaqueAuction.getSigner(). If that signer takes code, refunds stop until the signer is replaced.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Kubz waitlist refund: signed by the signer the auction contract reports. Read from source.
- KubzWaitlist.sol: checkValidity compares ECDSA.recover with opaqueAuction.getSigner(); setOpaqueAuctionContract is onlyOwner
- opaqueAuction (storage slot 151) = 0xd923af5d509042a3b24b711caaba8c408d4d4c23: getSigner() = 0xABCDdc2312d1B91b0b1Ee811b922b2E80798B7C2, owner() = 0x6c8ee01f…; that auction (same Kubz code as 0x4f01) has setSigner onlyOwner
- owner 0x6c8ee01f… is an EOA with nonce 2429 at block 26438999; withdrawSales is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $14,436 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setSigner on the auction contract 0xd923… (or points the waitlist at another auction) before the signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
