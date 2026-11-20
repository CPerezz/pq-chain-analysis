---
id: gratitudecrowdsale-c22407b1-fixed-gas-recovery
title: "GratitudeCrowdsale: fixed gas for ecrecover below EIP-8151's price"
status: not-affected
severity: NONE
patterns: [PQ-14]
impact: none
contracts:
- address: "0xc22407b1f34e494b7f85187fafc2ce5d13871ffb"
  family: "41c6f38fcd0778362c91521e6105700b"
  name: "GratitudeCrowdsale"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  note: "Refuted: finalized in 2017, no balance, and the callback can never matter again."
---

## Summary

GratitudeCrowdsale is already finalized (isFinalized=1, hasRandom=1) and holds 0 ETH. The random value only picked the golden-ticket winner, so the proof path is dead code now.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- isFinalized()=1, hasRandom()=1, hasRate()=1, weiRaised 0.65 ETH, endTime 1514160000 (2017) at block 26438999 [cast call]
- ETH balance 0 [cast balance]
- finalization() requires hasRandom and then sends all ETH to MSF/community; buyTokens is closed (validPurchase is time-bounded) [sourcify source]
- No refund path exists (RefundVault is declared but unused), which is moot: the funds already left at finalization [source]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
