---
id: rootpriceoracle-61f8be7f-signed-shortcut-lost
title: "RootPriceOracle: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x61f8be7fd721e80c0249829eae6f0daf21bc2cac"
  family: "92cd02e2814b8cbe6993926916943384"
  name: "RootPriceOracle"
  upgradeable: "no"
  rating: NONE
  txs_90d: 2540
  last_active: 2026-11-18
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
  note: "claim wrong for this address: no ecrecover path"
---

## Summary

Tokemak RootPriceOracle; the permit reading came from AutopoolToken.sol, a library bundled in the verified source but not part of this contract.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Tokemak AutopoolToken permit: ECDSA.recover must equal the owner named in the call. Read (function text).
- dossier facts: 'no recovery found in its bytecode', 0 recoveries in the window
- no permit (0xd505accf) and no approve selector in runtime code at block
- source bundle shows AutopoolToken.sol only as an import set of the oracle compilation

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 2,540 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
