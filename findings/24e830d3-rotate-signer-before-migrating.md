---
id: 24e830d3-rotate-signer-before-migrating
title: "0x24e830d3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x24e830d3205e08bc124d8de8a3cfea28cab8a313"
  family: "899b80f16ac757c4460f71a720204749"
  upgradeable: "no"
  rating: LOW
  value_usd: 7038
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 2437
  last_active: 2026-11-18
  recoveries_14d: 585
fix:
  layer: onchain-config
  who_acts: "owner 0x8A746Def…AE16 (EOA with 7702 delegation)"
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
  note: "Owner-only setter, live owner (an EOA with a 7702 delegation is still controlled by its key)."
---

## Summary

Unverified contract checking claims/withdrawals against a stored signer. A signer with code fails.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setSigner). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall: setSigner(address) requires msg.sender == owner (OwnableUnauthorizedAccount 0x118cdaa7)
- signer() = 0x8c722b8a…; owner() = 0x8A746Def6502AE8BaB2F2ab024a90788a929AE16, code 0xef0100… (7702 delegation), nonce 146

## Impact and exposure

- Value held at block 26,438,999: $7,038 (ETH and 49 priced tokens).
- Activity: 2,437 transactions called it in the 90 days before that block; last on 2026-11-18.
- 585 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls setSigner with a key without code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
