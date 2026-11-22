---
id: 59bd11f8-fixed-gas-recovery
title: "0x59bd11f8: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x59bd11f8a5a833f26723d044cbb501a40c9c5e43"
  family: "62c047931ca3e62a406c955caf2e4ce1"
  upgradeable: "no"
  rating: CRITICAL
  value_usd: 45
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "depositor 0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c (only depositor) exits before activation; operator proxy owner 0x0ea6b5edc8905c85514b3676703f1bfe6ec260ad commits the block carrying the exit"
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
  note: "No update path. After activation, fraud that spends someone else's deposit with a forged signature can't be proven, so whoever commits the block (the operator, or per Block.yulp anyone after SUBMISSION_DELAY [INFERENCE: deployed build differs slightly from commit 8e451045]) can steal deposits from people who did nothing: CRITICAL. The tiny balance (≈$45) doesn't lower the rating."
---

## Summary

Early Fuel v1 rollup (Yul+, v1.0.0, deployed 2020-12-31). Its fraud proofs for signature witnesses (proveInvalidWitness, proveInvalidSum) send 3,000 gas to ecrecover and revert when it fails. After activation every Signature-witness recovery reverts, so a block that spends someone's deposit or UTXO with a forged signature can no longer be proven fraudulent and finalizes after ~93k blocks. Withdrawals, deposits and block commits never touch 0x01 and keep working, which is what lets the forged spend be cashed out. The contract still holds an unspent user deposit.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode: recover routine at pc 0x1891 does CALL(gas=0x0bb8, to=0x01, in 0x00..0x80, out 0x80..0xa0); if success==0 it REVERTs (pc 0x18c5-0x18d4). Matches FuelLabs/fuel-v1-contracts Witness.yulp at commit 8e451045b9: call(3000,1,0,0,128,128,32) + require(gt(result,0), error"ecrecover") (master later dropped the require).
- Constant-stack reachability over the dispatcher (no unresolved jumps): only proveInvalidWitness(bytes,bytes) 0x67df9aa7 (via the per-input recoverWitness loop, call site 0x29db) and proveInvalidSum(bytes,bytes) 0x84e9520c (via verifyWitness, sites 0x5bca/0x5bee/0x5c18) reach the CALL at 0x18c4; deposit, commitRoot, commitBlock, withdraw, bondWithdraw, proveMalformedBlock, proveInvalidTransaction, proveInvalidInput, proveDoubleSpend do not.
- State at block 26438999: blockTip()=3, penalty()=0, operator()=0xb02b12bf… (Fuel Proxy owned by EOA 0x0ea6b5ed…, nonce 841); ETH 0.003, DAI 20e18 (depositAt(0xd2a8…,1,11562584)=20e18), USDC 20e6; all from 5 DepositMade events by 0xd2a8dd8f… (2020-12-31/2021-01-01). The only withdrawals (3× 0x227167f1, block 11696535-43) were the operator's 0.5 ETH bond withdrawals, so the user deposits are unspent.
- Constructor tail: FINALIZATION_DELAY 93046, SUBMISSION_DELAY 0x81ce, BOND_SIZE 0.5 ETH; no proxy slot, no upgrade/kill function among the 36 selectors.

## Impact and exposure

- Value held at block 26,438,999: $45 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No code fix. Before activation the depositor must exit: a rollup tx spending the deposits into withdrawal outputs, committed by the operator (or by anyone once the root is older than SUBMISSION_DELAY, per the source), then withdraw() after FINALIZATION_DELAY. Then stop using the deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry.
