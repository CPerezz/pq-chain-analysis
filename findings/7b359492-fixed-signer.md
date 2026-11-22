---
id: 7b359492-fixed-signer
title: "0x7b359492: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x7b359492afcbaf46e83a3c0c79f0a44a50a4591b"
  family: "08fde0aa87866469de2b95acfea3f2d5"
  copies: 2
  upgradeable: "no"
  rating: LOW
  value_usd: 3760
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x53e3a3bc… (7702-delegated EOA)"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The same act (moving the funds, any call) stays open through the owner's direct execute()/withdraw()."
---

## Summary

Owner-controlled ERC-1271 helper: isValidSignature accepts signatures recovered to the constant owner 0x53e3a3bc…, and execute/withdraw take the owner's direct calls. If the owner address took real code, 1271 approvals would stop, but the owner still moves everything through execute().

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ERC-1271 contract with four selectors answering for a signer that is a constant in its code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode/decompile: isValidSignature compares the recovered address with 0x53e3a3bc2762a5f683751de3efe1bdf9631008c4; execute(b61d27f6) and withdraw(2e1a7d4d) require msg.sender == that address
- cast code of the owner at 26438999 = 0xef010063c0c19a…: a 7702 delegation, which EIP-8151 still lets recover
- No EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $3,760 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed; the owner acts through direct execute() calls.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
