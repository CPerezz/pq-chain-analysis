---
id: charmsapply-02177ffa-signed-shortcut-lost
title: "CharmsApply: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x02177ffa1d7fbb35f2c444ee89b1f9de7b270b4f"
  family: "0c9a48981dd278b1f3f8b0aab48e6958"
  copies: 15
  name: "CharmsApply"
  upgradeable: "yes"
  rating: NONE
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 38
  last_active: 2026-11-04
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

`CharmsApply` at `0x02177ffa1d7fbb35f2c444ee89b1f9de7b270b4f`, with 14 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: CharmsApply _authorize: every owner but the caller signs, by SignatureChecker (ECDSA, or ERC-1271). Read (function text).
- Not affected: the reading for this address says the code asks a signer with code through ERC-1271 (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens, over 15 addresses).
- Activity: 38 transactions called it in the 90 days before that block; last on 2026-11-04.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
