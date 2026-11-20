---
id: spaceandtime-2c9973f4-signed-shortcut-lost
title: "SpaceAndTime: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2c9973f40716d34e13bf86502b9404a25959e311"
  family: "8b84febc252a00a97064e75676341447"
  copies: 4
  name: "SpaceAndTime"
  label: "Space and Time: SXT Token"
  upgradeable: "no"
  rating: LOW
  txs_90d: 13937
  last_active: 2026-11-18
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "the affected holder, by calling approve/delegate itself"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: same act open by approve/delegate to the same party; only a signing convenience is lost."
---

## Summary

SpaceAndTime: permit and delegateBySig require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- delegate(address) is the direct path for delegateBySig (0x5c19a95c present)
- row note: delegateBySig (OZ 5 Votes): whoever signed is the account that delegates / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 13,937 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve/delegate directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
