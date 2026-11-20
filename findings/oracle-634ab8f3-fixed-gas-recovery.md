---
id: oracle-634ab8f3-fixed-gas-recovery
title: "Oracle: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x634ab8f3f791a905b6e6ea72c33483401ed56e6b"
  family: "60ccf699d1f55fbe08434712ceccd390"
  name: "Oracle"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 931
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "ENS-resolved controller"
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
  verdict: confirmed
  rating: MEDIUM
  note: "MEDIUM: rate updates die for good (no update path); claim() by the controller is a separate sweep path, not the rate update restored."
---

## Summary

TokenCard-style rate Oracle (ENS registry, tokenWhitelistNode, controllerNode). The ecrecover in its Oraclize __callback proof check fails at 3,000 gas, so token-rate updates stop; held assets can still be claimed.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode: 6000 6001 610bb8 f1, a constant 3,000 gas to 0x01; heimdall shows ecrecover in __callback 0x27dc297e and 0x38bbfa50
- claim(address,address,uint256) 0x996cba68 resolves controllerNode through ENS and moves assets out, a separate function from the broken rate update (decompiled; controller check partly decompiled)
- balance 0.516 ETH; no setters or upgrade for the rate-update path

## Impact and exposure

- Value held at block 26,438,999: $931 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for the funds: the controller can claim the ETH; rate updates have no update path and stay broken.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
