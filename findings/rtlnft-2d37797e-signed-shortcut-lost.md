---
id: rtlnft-2d37797e-signed-shortcut-lost
title: "RtlNft: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x2d37797ee943f4c5e89edc3c520f01dc3f1f2aef"
  family: "41e809b35c1fa3a8868b78439f244140"
  copies: 4
  name: "RtlNft"
  label: "Onrail: LOAN-NFT Token"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 43
  last_active: 2026-11-10
  recoveries_14d: 4
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: executed
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

`RtlNft` at `0x2d37797ee943f4c5e89edc3c520f01dc3f1f2aef` (Etherscan tag: Onrail: LOAN-NFT Token), with 3 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: gasless meta-transactions: the recovered signer becomes the acting sender (Gasless.sol, line read); the same functions also take a direct call (_claim read). Read by hand. Executed: a real transaction reverts with code at the signer.
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 43 transactions called it in the 90 days before that block; last on 2026-11-10.
- 4 signature recoveries in the study's two-week trace window.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
