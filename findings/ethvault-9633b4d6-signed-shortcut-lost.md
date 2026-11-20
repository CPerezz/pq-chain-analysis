---
id: ethvault-9633b4d6-signed-shortcut-lost
title: "EthVault: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x9633b4d631d363fc8337fad80a6d0932e8767662"
  family: "d8ea11fc442a2ed78b6d02f665a34e26"
  copies: 12
  name: "EthVault"
  upgradeable: "yes"
  rating: NONE
  value_usd: 2526
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-08-29
fix:
  layer: none
  who_acts: "nobody: not affected"
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
  verdict: refuted
  rating: NONE
  note: "reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025)"
---

## Summary

`EthVault` at `0x9633b4d631d363fc8337fad80a6d0932e8767662`, with 11 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: StakeWise registerValidators: the validators manager calls itself, or its signature is checked with SignatureChecker (ECDSA, then ERC-1271). Read from source.
- Not affected: the reading for this address says the code asks a signer with code through ERC-1271 (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $2,526 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-08-29.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
