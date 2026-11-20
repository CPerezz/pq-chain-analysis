---
id: tokenizedstrategy-b646af5c-signed-shortcut-lost
title: "TokenizedStrategy: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb646af5c5176eb8a3de8c65ba0fb827520644ca7"
  family: "873b9ba15da43c1e01ff6a1e3fb1e513"
  copies: 220
  name: "TokenizedStrategy"
  label: "Yearn: ysUSDC Token 4"
  upgradeable: "yes"
  rating: LOW
  value_usd: 33745
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 533
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the holder"
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $33745, txs_90d 533."
---

## Summary

TokenizedStrategy exposes an EIP-2612-style permit; under EIP-8151 a holder whose address has code can no longer approve by signature.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit in the Solmate form (text cut after the recovery): the owner named must equal the recovered address. Read from source.
- TokenizedStrategy: permit-style function compares the recovered address with the owner named in the call, no ERC-1271 branch (dossier source; study: permit in the Solmate form (text cut after the recovery): the owner named must equal the recovered address)
- approve is a public function the holder calls directly (dossier source, `function approve` present)
- The holder is the same party in both paths; no setter or live admin needed

## Impact and exposure

- Value held at block 26,438,999: $33,745 (ETH and 49 priced tokens, over 220 addresses).
- Activity: 533 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The holder calls approve itself (or uses another approval method).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
