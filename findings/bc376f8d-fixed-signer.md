---
id: bc376f8d-fixed-signer
title: "0xbc376f8d: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd"
  family: "3d80697e3abbd27814762366d0ea66ba"
  copies: 2
  upgradeable: "yes"
  rating: LOW
  txs_90d: 10
  last_active: 2026-11-10
fix:
  layer: account-migration
  who_acts: "the holder of the account key 0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd"
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
  note: "LOW: a 7702 re-delegation by a live key holder is a simple update."
---

## Summary

An EIP-7702-delegated account (small sweep contracts (6); inferred: withdrawals signed by a fixed party); EIP-8151 makes the signer check fail once the signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: small sweep contracts (6); inferred: withdrawals signed by a fixed party. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: 7702 account: re-delegates.
- cast code 0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd at block 26438999: 23 bytes starting 0xef0100 (delegation indicator), so this is an EOA running delegated code
- cast nonce 0xbc376f8d9ec9a5ebe24bbd2b48a9ff98847965fd at block 26438999 = 15: the key holder has sent transactions and can sign a new 7702 authorization

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 10 transactions called it in the 90 days before that block; last on 2026-11-10.

## Remediation

Account key holder re-delegates to code that checks a replaceable signer or accepts ERC-1271, or signs with an EOA signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
