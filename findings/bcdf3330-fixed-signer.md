---
id: bcdf3330-fixed-signer
title: "0xbcdf3330: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbcdf3330a734beea94d8c793c2719ed6a782da97"
  family: "748e11a011a4c6590d5f666ba008a6a3"
  copies: 11283
  upgradeable: "yes"
  rating: LOW
  value_usd: 286
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1776
  last_active: 2026-11-13
fix:
  layer: account-migration
  who_acts: "each delegating account's key holder"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW through 7702 re-delegation."
---

## Summary

An EOA delegated by 7702 to 0x2c6f0179…, a delegate used by 11,283 accounts that accepts a constant signer.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 7702 delegate used by 11,283 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Bytecode and names.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code at 26438999 = 0xef01002c6f01799fa9db1e7f2797e5ba892b72b865571d (delegation indicator)
- cast nonce = 45: the key holder is live

## Impact and exposure

- Value held at block 26,438,999: $286 (ETH and 49 priced tokens, over 11,283 addresses).
- Activity: 1,776 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Re-delegate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
