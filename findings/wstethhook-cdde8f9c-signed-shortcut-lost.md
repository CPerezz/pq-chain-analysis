---
id: wstethhook-cdde8f9c-signed-shortcut-lost
title: "WstETHHook: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xcdde8f9c3414a00f804e5c565eed9949ad17e888"
  family: "33682964fd8d77fedc48ed77c4bc3c8e"
  name: "WstETHHook"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1022
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
  note: "No signature recovery in deployed code."
---

## Summary

WstETHHook is a Uniswap v4 wrapper hook; the solmate permit the study matched is in a vendored v4-core/solmate library file, not compiled into this hook, so nothing here recovers a signer.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read (function text).
- Dossier scanner.json (complete: true): external calls only to PoolManager 0x…4444c5dc, stETH and wstETH; none to precompile 0x01.
- Bytecode at block 26438999 has no permit selector 0xd505accf; source.json marks ecrecover only in src/pkgs/v4-periphery/lib/v4-core/lib/solmate/src/tokens/ERC20.sol.
- txs.json: "no recovery by this code in the traced window".

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1,022 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
