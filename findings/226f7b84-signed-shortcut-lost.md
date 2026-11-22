---
id: 226f7b84-signed-shortcut-lost
title: "0x226f7b84 (tagged Union Protocol: UNN Token): signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0x226f7b842e0f0120b7e194d05432b3fd14773a9d"
  family: "553d43f39216884241420c9926ceb99c"
  label: "Union Protocol: UNN Token"
  upgradeable: "no"
  rating: LOW
  value_usd: 13173
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 964
  last_active: 2026-11-17
fix:
  layer: offchain
  who_acts: "the affected holder (signer with code)"
evidence:
  level: bytecode
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
  note: "Direct twins by selector; bodies not read. Value $13173, txs_90d 964 (not rating inputs)."
---

## Summary

Union Protocol UNN token (unverified): permit and delegateVoteBySignature; a holder with code calls approve/delegateVote itself.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: token with permit and vote delegation by signature. Bytecode and names.
- scanner selectors + _selectors: approve 0x095ea7b3, permit 0xd505accf, delegateVote(address) 0xb31e1d4d, delegateVoteBySignature 0xc9d21392

## Impact and exposure

- Value held at block 26,438,999: $13,173 (ETH and 49 priced tokens).
- Activity: 964 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Call approve / delegateVote directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
