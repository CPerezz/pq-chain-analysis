---
id: 4bacc118-rotate-signer-before-migrating
title: "0x4bacc118: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x4bacc118f9cee2f6e9b52aab317f8b5aaf2503f5"
  family: "51f037859b9bba46d40ed0895ab3fe25"
  upgradeable: "no"
  rating: LOW
  value_usd: 236758
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 520
  last_active: 2026-11-17
  recoveries_14d: 84
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xebc0…e938"
evidence:
  level: executed
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
  note: "Live owner setter plus non-signed path."
---

## Summary

Liquidity/messaging contract: fast-withdrawal permits need user and operator (slot 8) signatures.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: deposits by permit; one stored key and an owner that can be handed over. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- owner sets slot 8 via 0xd308b7bc
- owner()=0xebc09c7e…e938 EOA nonce 60
- normal payout by message delivery (0x56d5d475) needs no signature

## Impact and exposure

- Value held at block 26,438,999: $236,758 (ETH and 49 priced tokens).
- Activity: 520 transactions called it in the 90 days before that block; last on 2026-11-17.
- 84 signature recoveries in the study's two-week trace window.

## Remediation

Owner replaces operator key; users use normal withdrawal.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
