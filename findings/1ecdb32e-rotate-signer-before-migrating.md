---
id: 1ecdb32e-rotate-signer-before-migrating
title: "0x1ecdb32e (tagged Whales Market: Markets): signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1ecdb32e59e948c010a189a0798c674a2d0c6603"
  family: "4af46768fd13a396a0c0c3cf2ee5092d"
  copies: 2
  label: "Whales Market: Markets"
  upgradeable: "yes"
  admin: "ProxyAdmin 0xeb5e772919661f455619a4cabd9b2b64715505e6 owned by 0x914B776bf3C8915FD47Fd31B960F5F3990AA35B3"
  rating: LOW
  value_usd: 291617
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 11
  last_active: 2026-10-13
fix:
  layer: account-migration
  who_acts: "buyer/seller (key holder)"
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
  note: "Key holder rotation plus live upgrade."
---

## Summary

Offer/order collateral contract: relayer moves an order's buyer/seller slot on that party's signature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (grantRole, revokeRole, updateConfig). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- 0x012fe806/0x61ac7433 by role relayer on current party's signature; 0x236e786f direct (reading.keys)
- EIP-1967 admin 0xeb5e7729…05e6 ProxyAdmin owned by 0x914B776b…5B3, 7702-delegated EOA nonce 220

## Impact and exposure

- Value held at block 26,438,999: $291,617 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 11 transactions called it in the 90 days before that block; last on 2026-10-13.

## Remediation

Party re-assigns its slot to a new EOA before migrating, or upgrade.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
