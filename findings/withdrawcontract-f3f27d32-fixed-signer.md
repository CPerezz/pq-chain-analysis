---
id: withdrawcontract-f3f27d32-fixed-signer
title: "WithdrawContract: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xf3f27d327d67d4a262d127e4ee596082acaac66b"
  family: "29559a4881979141e9c0bbfdadd523c3"
  copies: 4
  name: "WithdrawContract"
  upgradeable: "no"
  rating: HIGH
  value_usd: 303
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "operator holding the signer key"
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
  rating: HIGH
  note: "No update path; held tokens back users' signed withdrawals and nothing else can move them → HIGH. If the reviewer reads the pool as the operator's own float, it is MEDIUM."
---

## Summary

WithdrawContract.withdraw is the only function that moves tokens held by the contract, and it requires a signature by signer, which is set in the constructor with no setter. pay() forwards user payments straight out; contractAdmin is never set and no function uses onlyAdmin.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: WithdrawContract withdraw: each withdrawal needs the signer set in the constructor, with no setter; users pay in through pay(). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- t.sol: signer written only in constructor; verify() == signer gates withdraw
- signer() = 0x8b85a3AF…426C (code 0x today); contractAdmin() = 0x0
- pay() transfers the full amount to receiverA/B and feeReceiver; there is no rescue or owner path

## Impact and exposure

- Value held at block 26,438,999: $303 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator processes all withdrawals before the signer key takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
