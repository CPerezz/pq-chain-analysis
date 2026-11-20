---
id: dcn-51382330-rotate-signer-before-migrating
title: "DCN: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x51382330280f5198ff415d54646cbea59593973c"
  family: "d1c513168318464fae0f635d4d3b4412"
  copies: 2
  name: "DCN"
  upgradeable: "no"
  rating: LOW
  value_usd: 13895
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the user (recovery address or trade address)"
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
  note: "LOW: the user rotates their own key, and funds leave by direct calls."
---

## Summary

DCN exchange: exchange_set_limits recovers a signature that must equal the session's trade address. A user key that takes code cannot authorise limit updates.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: DCN: limit updates are signed by the user's registered trade key (assembly; the registration functions were not read). Read by hand.
- DCN.sol:1505-1515: ecrecover result compared with sload(session_ptr+1), the session trade address
- user_set_trade_address (DCN.sol:451) is callable by the user's recovery address; user_session_set_unlock_at stores caller as the session trade address
- user_withdraw and transfer_from_session are direct calls gated by the trade address

## Impact and exposure

- Value held at block 26,438,999: $13,895 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The user sets a new trade address through the recovery address and re-opens the session from it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
