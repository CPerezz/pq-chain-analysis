---
id: lenderdeployer-c68f3e77-signed-shortcut-lost
title: "LenderDeployer: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc68f3e777f28c52ff9db0276a14f59d96aa2f931"
  family: "e00a087ac7ceefd9603665d04fd248bf"
  copies: 2
  name: "LenderDeployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1438
  last_active: 2026-11-17
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
  note: "The matched ecrecover is not reachable from this deployed code."
---

## Summary

LenderDeployer is a factory; the solmate ERC20 permit the study matched lives in library/source-bundle code (Coin/Vault), not in the bytecode deployed at this address, so EIP-8151 changes nothing here beyond gas.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: solmate permit: the recovered address must be the owner named in the call, zero rejected; nothing else is accepted here. Read (function text).
- Dossier scanner.json (complete: true) lists no STATICCALL to precompile 0x01 at this address.
- Bytecode at block 26438999 contains no permit selector 0xd505accf; source.json marks ecrecover only in lib/solmate/src/tokens/ERC20.sol.
- txs.json: "no recovery by this code in the traced window".

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,438 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None at this address (child Coin/Vault deployments, if any, are separate addresses).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
