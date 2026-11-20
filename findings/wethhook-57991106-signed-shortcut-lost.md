---
id: wethhook-57991106-signed-shortcut-lost
title: "WETHHook: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x57991106cb7aa27e2771beda0d6522f68524a888"
  family: "13af2b40d088462a0ac2c2cb457eb659"
  name: "WETHHook"
  upgradeable: "no"
  rating: NONE
  txs_90d: 20827
  last_active: 2026-11-18
fix:
  layer: none
  who_acts: "nobody"
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
  note: "No signed path in the deployed contract; the row attributed bundled library code to it."
---

## Summary

Uniswap v4 WETHHook; it imports solmate WETH only as the external token's type; the solmate permit belongs to WETH, not to the hook.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read (function text).
- WETHHook.sol imports WETH, BaseTokenWrapperHook, IPoolManager, Currency; BaseTokenWrapperHook has no recover/permit
- deployed code at 26438999 lacks permit (0xd505accf) and approve (0x095ea7b3) selectors

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 20,827 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none needed

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
