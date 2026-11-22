---
id: waitlist-74699d5f-rotate-signer-before-migrating
title: "Waitlist: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x74699d5fb553afed0360a6a266981dcd98d9dfa4"
  family: "11591c5eff841ce1b4c2068524a631bf"
  copies: 7
  name: "Waitlist"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xf025…744c (owner EOA 0x759c…91C1)"
  rating: LOW
  value_usd: 27068
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x6c8e…755f"
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
  note: "Live EOA owner and live ProxyAdmin."
---

## Summary

Waitlist (proxy): refund requires a signature from blindAuction.getSigner().

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: Waitlist refund: signed by the signer the auction contract reports. Read from source.
- setBlindAuctionContract is onlyOwner (Waitlist.sol:120), so the owner can repoint the signer source
- owner() = 0x6c8e…755f, EOA nonce 2429 at 26438999
- EIP-1967 admin = ProxyAdmin 0xf025…744c, owner EOA 0x759c…91C1 nonce 1780 (live upgrade); withdrawSales onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $27,068 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner rotates the signer on the auction contract or repoints blindAuction, or upgrades.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
