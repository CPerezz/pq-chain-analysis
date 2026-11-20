---
id: 005c44ab-fixed-signer
title: "0x005c44ab: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x005c44ab6c89be55669b2b6b9c0b0e76bed7020d"
  family: "db48ee0104500b94f36b3bd30bf268f1"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 160
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "account owners"
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
  rating: LOW
  note: "The same act stays open to the affected party by a direct self-call, and the EOA key can re-delegate."
---

## Summary

A 7702 delegate where calls signed by the constant operator 0x135e…6bfb (an EOA) move the account's assets. The authorisation routine returns at once when CALLER == ADDRESS, so the account owner can still do the same transfers directly. Only the operator's signed shortcut dies.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: 7702 delegate used by 2,701 accounts: it accepts the signature of a signer that is a constant in the code, not the account's own key. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: the constant 0x135e7a48…6bfb is present and has no code at block 26438999
- Disassembly at pc 0x1d21: ADDRESS, CALLER, SUB, ISZERO, then a JUMPI skips the signature check for self-calls
- Dossier reading: the signed functions move ERC-20/721/1155/ETH and run swaps; signature failure reverts

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 160 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None needed. Accounts act directly or re-delegate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
