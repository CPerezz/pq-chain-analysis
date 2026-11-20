---
id: daotimelock-1dd03b88-signed-shortcut-lost
title: "DAOTimelock: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x1dd03b88d166694073308685f8a2c57b46987300"
  family: "d996a094743f23ab35192e012e269df1"
  copies: 9
  name: "DAOTimelock"
  upgradeable: "no"
  rating: NONE
  value_usd: 253
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-16
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

`DAOTimelock` at `0x1dd03b88d166694073308685f8a2c57b46987300`, with 8 more addresses running its code. Not affected: reviewed through the root issue's mechanism, a random sample and mechanical checks (D-025).

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Governor _validateVoteSig: SignatureChecker on the voter named (ECDSA, or its ERC-1271) / Governor _validateExtendedVoteSig: SignatureChecker on the voter named / delegateBySig (OZ 5 Votes): whoever…. Read (function text).
- Not affected: the scanner's complete analysis of this address's code finds no call to the ecrecover precompile, so EIP-8151 changes nothing here; the row came from a reading of related code (D-025 mechanism review)

## Impact and exposure

- Value held at block 26,438,999: $253 (ETH and 49 priced tokens, over 9 addresses).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-16.

## Remediation

None needed for funds; add ERC-1271 to keep gasless flows.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
