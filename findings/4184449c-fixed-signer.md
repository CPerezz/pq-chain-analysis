---
id: 4184449c-fixed-signer
title: "0x4184449c: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4184449cd85cdfd4836fd282214174850d5fca9c"
  family: "a45132c25f1e0e091ad74a844dfddac5"
  copies: 24
  upgradeable: "no"
  rating: HIGH
  value_usd: 71968
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 290
  last_active: 2026-11-17
  recoveries_14d: 49
fix:
  layer: new-deployment
  who_acts: "the operator keeps the key without code, or moves users to a new deployment"
evidence:
  level: executed
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
  rating: HIGH
  note: "wallet signers fixed"
---

## Summary

Contract `0x4184449cd85cdfd4836fd282214174850d5fca9c`, with 23 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: BitGo pattern: a stored signer other than the caller; no function name that changes signers. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Bytecode and names: the BitGo wallet pattern (a stored signer other than the caller); no function changes the signers.
- The 24 addresses are fixed delegates; no upgrade.
- Executed: a real transaction reverts once the second signer has code. 290 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $71,968 (ETH and 49 priced tokens, over 24 addresses).
- Activity: 290 transactions called it in the 90 days before that block; last on 2026-11-17.
- 49 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
