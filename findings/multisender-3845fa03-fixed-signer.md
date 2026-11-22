---
id: multisender-3845fa03-fixed-signer
title: "Multisender: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3845fa0348d45284a4c5041195353b08091915c8"
  family: "f676074fa82707a44168745fd4ce818c"
  copies: 2
  name: "Multisender"
  upgradeable: "no"
  rating: LOW
  txs_90d: 38
  last_active: 2026-11-13
  recoveries_14d: 28
fix:
  layer: none
  who_acts: "custody wallets"
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
  note: "The same act stays open to the affected party by a direct call."
---

## Summary

Multisender: the *Multisig functions need signatures from both immutable signers (0x1877… a 7702-delegated EOA, 0x008a… an EOA). They only pull from custody wallets that approved the custodial Holder. If a signer's key gets code, custody wallets still hold their funds and can send them with the open send()/sendBatch() as msg.sender.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Multisender: exactly two signatures, from two addresses fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source Multisender.sol: _SIGN_0/_SIGN_1 are immutable; _verifySignatures requires both by position
- signers() = 0x1877…129e (0xef0100 delegation), 0x008A…BC6e (no code)
- Funds stay in the custody wallets; send() draws from msg.sender via the direct Holder

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 38 transactions called it in the 90 days before that block; last on 2026-11-13.
- 28 signature recoveries in the study's two-week trace window.

## Remediation

None needed; custody wallets revoke the approval and act directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
