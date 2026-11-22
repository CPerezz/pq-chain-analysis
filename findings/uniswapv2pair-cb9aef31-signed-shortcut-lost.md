---
id: uniswapv2pair-cb9aef31-signed-shortcut-lost
title: "UniswapV2Pair: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcb9aef31e7b2359b769a735f485bc7040ede25ec"
  family: "9e4b1e3fadfb3e3b5b6a762255a867c5"
  copies: 47
  name: "UniswapV2Pair"
  label: "deployed by Radiant Capital: Deployer 2"
  upgradeable: "no"
  rating: LOW
  value_usd: 18587
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1750
  last_active: 2026-11-18
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
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $18587, txs_90d 1750."
---

## Summary

UniswapV2Pair: token bytecode with a permit; under EIP-8151 a holder whose address has code can no longer use permit.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: permit: the owner named in the call must equal the recovered address; the holder can call approve itself. Read from source.
- UniswapV2Pair: bytecode carries both permit selector 0xd505accf and approve selector 0x095ea7b3 (dossier code.hex)
- No verified source; study classed it permit-like by bytecode and names
- approve is called by the holder itself, same party as permit

## Impact and exposure

- Value held at block 26,438,999: $18,587 (ETH and 49 priced tokens, over 47 addresses).
- Activity: 1,750 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The holder calls approve itself.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
