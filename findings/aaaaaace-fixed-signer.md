---
id: aaaaaace-fixed-signer
title: "0xaaaaaace: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xaaaaaaceeed2b24ef8083f8703c6d6f3a36e1137"
  family: "9fa16c2fb67841bd019dcf0af995557f"
  upgradeable: "yes"
  rating: LOW
  value_usd: 20111
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 19
  last_active: 2026-11-12
fix:
  layer: account-migration
  who_acts: "the account's key holder"
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
  note: "Re-delegation by the live key holder fixes it: LOW."
---

## Summary

An EOA delegated by 7702 to 0xe3115679… whose logic accepts a constant signer. If that signer held code, the signed path would stop for this account.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code at 26438999 = 0xef0100e311567908a3c8bde4f2b6743fd273d01960d00d (23 bytes, a delegation indicator)
- cast nonce = 5045: the key holder is live and can send a new 7702 authorization

## Impact and exposure

- Value held at block 26,438,999: $20,111 (ETH and 49 priced tokens).
- Activity: 19 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

The account re-delegates to a delegate without the fixed signer, or calls directly with its own key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
