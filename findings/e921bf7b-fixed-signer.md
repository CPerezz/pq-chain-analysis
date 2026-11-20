---
id: e921bf7b-fixed-signer
title: "0xe921bf7b (tagged deployed by Relay: Solver 0xa67...fbb): signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe921bf7b0c5420d4aecedcd59aff1cc79504f9f2"
  family: "8e6c8e5c7bd073d11dba6fd4ab7215df"
  copies: 4
  label: "deployed by Relay: Solver 0xa67...fbb"
  upgradeable: "no"
  rating: LOW
  txs_90d: 14
  last_active: 2026-11-16
  recoveries_14d: 3
fix:
  layer: none
  who_acts: "owner"
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
  note: "The owner keeps the same act by direct call, and nothing is held: LOW."
---

## Summary

Trading router/bot (UniversalRouter-style execute 0x3593564c, V4 unlockCallback). Its relayed signed-order path checks a signature by the constant owner 0x4c078f5c… (a 7702-delegated EOA today). The owner calls the contract directly: execute and withdraw (0xf3fef3a3) require msg.sender==owner. The contract holds no funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode PUSH32 0x…4c078f5c… used in CALLER EQ guards; the withdraw(address,uint256) guard is require(msg.sender==0x4c078f…) (heimdall).
- 0x4c078f… code 0xef0100… (delegation, not real code) (cast).
- Balance 0 ETH, 0 WETH, no ERC-20 received in the last 200k blocks.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-16.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

None; the owner acts directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
