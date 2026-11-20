---
id: 7c5fcccd-fixed-gas-recovery
title: "0x7c5fcccd: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x7c5fcccd3c94faf14a3a9391a7c52b734ac9fbd2"
  family: "dbf3d256dd92a2a3102194c90fe3280b"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 11
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "depositor 0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c exits before activation; operator proxy owner 0x0ea6b5edc8905c85514b3676703f1bfe6ec260ad commits the block carrying the exit"
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
  rating: CRITICAL
  note: "No update path. A forged-signature spend of the deposit can't be proven after activation, so the block producer can take the depositor's funds: CRITICAL. The tiny balance (≈$11) doesn't lower the rating."
---

## Summary

Same early Fuel v1 runtime as 0x59bd11f8 (deployed 2020-11-20); only the appended constructor data differs. Signature-witness fraud proofs (proveInvalidWitness, proveInvalidSum) revert once ecrecover with 3,000 gas fails, so after activation a block that spends the pending deposit with a forged signature can't be challenged. No block was ever committed and a 0.006 ETH user deposit sits unspent.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: recover routine at pc 0x1891 does CALL(gas=0x0bb8, to=0x01, in 0x00..0x80, out 0x80..0xa0); if success==0 it REVERTs (pc 0x18c5-0x18d4). Matches FuelLabs/fuel-v1-contracts Witness.yulp at commit 8e451045b9: call(3000,1,0,0,128,128,32) + require(gt(result,0), error"ecrecover") (master later dropped the require).
- Constant-stack reachability over the dispatcher (no unresolved jumps): only proveInvalidWitness(bytes,bytes) 0x67df9aa7 (via the per-input recoverWitness loop, call site 0x29db) and proveInvalidSum(bytes,bytes) 0x84e9520c (via verifyWitness, sites 0x5bca/0x5bee/0x5c18) reach the CALL at 0x18c4; deposit, commitRoot, commitBlock, withdraw, bondWithdraw, proveMalformedBlock, proveInvalidTransaction, proveInvalidInput, proveDoubleSpend do not.
- Runtime is byte-identical to 0x59bd11f8 up to offset 23717; the differing bytes 23717-23862 are the appended constructor data (operator, SUBMISSION_DELAY 0xb5ba, BOND_SIZE 1 ETH).
- State at block 26438999: blockTip()=0, operator()=0x416fd705… (Fuel Proxy, same owner 0x0ea6b5ed…), balance 0.006 ETH = depositAt(0xd2a8dd8f…,0,11558288)=6e15 (single DepositMade, block 11558288); no withdrawals ever.

## Impact and exposure

- Value held at block 26,438,999: $11 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No code fix. Before activation the depositor exits through a committed rollup block plus withdraw() after FINALIZATION_DELAY (93046 blocks). Then retire the deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
