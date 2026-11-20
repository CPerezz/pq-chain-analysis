---
id: 3d64bd58-rotate-signer-before-migrating
title: "0x3d64bd58: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3d64bd587300af85ae54007d350bfd293dc24581"
  family: "c43de8b9c2d38727c18fb7e8c830d173"
  copies: 2
  upgradeable: "yes"
  admin: "ProxyAdmin 0xb2d43c872de4b2a5844bd229cf0dbce84fb54f92 owned by 0x494f5d0Ef9d433AAd42EA6B6A0536b12Ce1976F6"
  rating: LOW
  value_usd: 42588
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 435
  last_active: 2026-11-17
  recoveries_14d: 16
fix:
  layer: contract-upgrade
  who_acts: "owner 0x494f5d0e (7702-delegated EOA)"
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
  note: "Live upgrade path through a live (7702-delegated) EOA."
---

## Summary

Wanchain WMB token bridge proxy (impl 0x9ee44137): inbound messages are verified against a stored key (recovered 0x18e822bb). A key with code makes inbound transfers revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setTrustedRemotes). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- EIP-1967 admin = ProxyAdmin 0xb2d43c87, owner 0x494f5d0Ef9d433AAd42EA6B6A0536b12Ce1976F6
- 0x494f…: EIP-7702 delegation code (0xef0100…), nonce 150, so a live EOA; it is also the bridge owner()
- Impl decompile: setTrustedRemotes/changeGateway/configWmbGateway present (owner-gated config)

## Impact and exposure

- Value held at block 26,438,999: $42,588 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 435 transactions called it in the 90 days before that block; last on 2026-11-17.
- 16 signature recoveries in the study's two-week trace window.

## Remediation

Owner reconfigures the gateway/remote or upgrades through the ProxyAdmin.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
