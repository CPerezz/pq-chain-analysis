---
id: be07ffc1-fixed-gas-recovery
title: "0xbe07ffc1: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xbe07ffc1f34479f38c6cc1fc04dbc665a23b25cf"
  family: "607282497f6600fca8d8e988aa622cb1"
  copies: 2
  upgradeable: "no"
  rating: NONE
  value_usd: 20
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none (issuer 0xb9088f18d6b7a15d67cbb82989f6436ee1b80592 can still call close() as before)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Every path that reaches the 3,000-gas ecrecover dies at the sale-end time check (2019-09-13) whatever ecrecover returns, and the only payout path, close(), doesn't use 0x01: refuted."
---

## Summary

Token sale (deployed 2019-09-11). Its signed purchases 0x91d93f90/0xa75aa061 STATICCALL ecrecover with 3,000 gas, but every purchase path ends at one shared require that needs block.timestamp < slot5 (2019-09-13 04:00 UTC), so purchases have been closed for good since 2019. close() never reaches 0x01 and still pays out.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: STATICCALL at pc 0xcba with gas PUSH2 0x0bb8 to address 0x01; constant-stack reachability: only selectors 0x91d93f90 and 0xa75aa061 reach it (not fallback, purchase(address) 0x25b31a97, or close() 0x43d726d6).
- All purchase effects (refund CALL 0x3b3, sold counter SSTORE 0x3d3, token transfer) are reachable from fallback/purchase/0x91d93f90/0xa75aa061 only through the require at 0x36e: flag(slot11)&& now>=slot4 && now<slot5 && amount>0; blocking 0x376 makes all of them unreachable. slot4=0x5d787848 (2019-09-11 04:30 UTC), slot5=0x5d7b1440 (2019-09-13 04:00 UTC); block 26438999 timestamp 1794969479.
- close(): require(caller==issuer slot0) and flag && (now<slot4
- now>=slot5
- sold==cap), then sends the token balance and ETH to the issuer. eth_call close() from the issuer at block 26438999 succeeds; purchase(address) with value reverts. It holds 999,890e18 'FST Tutorial Token' (0x5187eaf2…) + 0.011 ETH; flag slot11=1 (never closed).

## Impact and exposure

- Value held at block 26,438,999: $20 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for EIP-8151. The issuer can call close() to recover the leftover tokens and ETH at any time.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
