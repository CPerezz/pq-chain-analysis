---
id: 05d6c2fe-fixed-signer
title: "0x05d6c2fe: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x05d6c2fe80b25dfb89df6799e30d802744832f8b"
  family: "db48ee0104500b94f36b3bd30bf268f1"
  copies: 2701
  upgradeable: "yes"
  rating: LOW
  value_usd: 4792
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5009
  last_active: 2026-11-17
  recoveries_14d: 773
fix:
  layer: account-migration
  who_acts: "each delegating account's key holder"
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
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW through 7702 re-delegation. The row address is one delegating EOA, not the delegate code itself."
---

## Summary

An EOA delegated by 7702 to 0x2e13de87…, a delegate used by 2,701 accounts that accepts a constant signer, not the account's own key. A real transaction reverts once that signer holds code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 7702 delegate used by 2,701 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code at 26438999 = 0xef01002e13de8763a53a6af340930fadcad966ee79c845 (delegation indicator)
- cast nonce = 21: the key holder is live

## Impact and exposure

- Value held at block 26,438,999: $4,792 (ETH and 49 priced tokens, over 2,701 addresses).
- Activity: 5,009 transactions called it in the 90 days before that block; last on 2026-11-17.
- 773 signature recoveries in the study's two-week trace window.

## Remediation

Re-delegate to a delegate without the fixed signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
