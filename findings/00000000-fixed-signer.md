---
id: 00000000-fixed-signer
title: "0x00000000: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0000000025e904c59afdb33d50f982d46a7ff880"
  family: "b08f3659c0112d4a8ecd6780418b071f"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 2710
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: onchain-config
  who_acts: "owner 0x15bb8db08b63095f2717a3c4a2640a9079e5a219 (EOA, nonce 102)"
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
  note: "A setter replaces the accepted key and nothing is held, so LOW. Not fully verified: I inferred from the data offsets 0x40/0x61 that the caller-supplied payload picks the branch."
---

## Summary

Order-execution contract whose signed path accepts either the constant key 0x1d10068a… or the key in storage slot 3, which the owner can set with setGasAddress. The contract holds no ETH or WETH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a constant and a stored key; no setter name. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly at pc 4159-4490: the recovered address is compared to PUSH32 0x1d10068a52be21d526423b81ae275c4591ce7f04, and on a second branch to SLOAD slot 3
- setGasAddress(address) writes slot 3 behind require(msg.sender == owner) (heimdall decompile); slot 3 is 0 at block 26438999
- cast balance 0; WETH balanceOf 0; refundETH() pays the owner; owner 0x15bb… is an EOA with no code
- Constant signer 0x1d10… has no code (cast code)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 2,710 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Owner sets setGasAddress to a key that will stay code-free and signs on the slot-3 branch.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
