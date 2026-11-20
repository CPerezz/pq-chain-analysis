---
id: nestvaultpredicateproxy-f6f0111f-signed-shortcut-lost
title: "NestVaultPredicateProxy: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xf6f0111ff93f4c44e10613eb1677ce3175561588"
  family: "97f2c42b546e0e5192ed16a11d4e0a4c"
  copies: 2
  name: "NestVaultPredicateProxy"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 710
  last_active: 2026-11-17
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

`NestVaultPredicateProxy` at `0xf6f0111ff93f4c44e10613eb1677ce3175561588`, with 1 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: the account named must sign: ECDSA, else its ERC-1271 (SignatureChecker or the same by hand) / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / solmate permit: the…. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 710 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
