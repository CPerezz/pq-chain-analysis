---
id: degens-88888888-fixed-signer
title: "Degens: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8888888883585b9a8202db34d8b09d7252bfc61c"
  family: "279c46a28b0aef13f091d5f0c9ccfc4a"
  name: "Degens"
  upgradeable: "no"
  rating: LOW
  value_usd: 39730
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-10-22
fix:
  layer: none
  who_acts: "makers sign with a key without code; graders' matches are finalised after recoveryTime"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "nothing locked; signed paths stop for accounts with code only"
---

## Summary

`Degens` at `0x8888888883585b9a8202db34d8b09d7252bfc61c`. Orders must recover to their maker and matches to their graders, but no money is locked: withdrawals are direct calls and a match can be finalised by anyone after its recovery time.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Degens (sports betting): every order must recover to its maker (no ERC-1271), so a maker with code cannot have orders matched; withdrawals are direct. A match is graded by the graders committed in…. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Read by hand: every order must recover to its maker (no ERC-1271); a match is graded by graders committed in its matchId; after recoveryTime anyone can finalise; withdrawals are direct.
- A maker whose account has code can no longer have orders matched, but can withdraw and trade with another key.
- No proxy, no upgrade. 1 transaction in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $39,730 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-22.

## Remediation

None needed for funds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
