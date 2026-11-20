---
id: frxeth-d1738eb7-signed-shortcut-lost
title: "frxETH: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xd1738eb733a636d1b8665f48bc8a24da889c2562"
  family: "a967867880a1fae5b912fe7f0db1f6a1"
  copies: 7
  name: "frxETH"
  label: "deployed by Frax Finance: Deployer 4"
  upgradeable: "no"
  rating: LOW
  txs_90d: 25204
  last_active: 2026-11-18
  recoveries_14d: 19
fix:
  layer: none
  who_acts: "the affected holder, by calling approve itself"
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
  note: "LOW: same act open by approve to the same party; only a signing convenience is lost."
---

## Summary

frxETH: EIP-2612 permit require the holder's ECDSA signature; EIP-8151 fails it for a holder with code.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.
- approve(address,uint256) is the holder's direct path (selector 0x095ea7b3 in deployed code)
- row note: OpenZeppelin 4 permit: ECDSA.recover must equal the owner named in the call. Read from source. Executed: a real transaction reverts with code at the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 25,204 transactions called it in the 90 days before that block; last on 2026-11-18.
- 19 signature recoveries in the study's two-week trace window.

## Remediation

holder calls approve directly instead of signing

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
