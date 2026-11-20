---
id: eip-8151-fixed-gas-recovery
title: "Contracts that give ecrecover a fixed gas amount below EIP-8151's price: every valid signature fails from activation day"
status: candidate
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- {address: "0xc59162bbe31b2eca8e3d7d3401dc05f64e293f83", family: "bf52cbad6e524d92cbe9d706f69d3cd8", copies: 3, upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xe5e5214ccf899bfc77e4dd9858737902cc1f0b0a", family: "68b957711ed4ed3cfeee36cba3528373", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed gas"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

These contracts forward a fixed amount of gas to `ecrecover` that is below the price of a successful recovery under EIP-8151 (3,200 warm, 6,100 cold). 2 code families, 4 addresses, $0 held, 0 recoveries in the study's two-week window. Rows by rating: HIGH 2. 0 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- Fuel v1 `0x6880f6fd960d1581c2730a451a22eed1081cfd72`: `src/Witness.yulp` L137–144 of FuelLabs/fuel-v1-contracts@2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22 does `call(3000, 1, 0, 0, 128, 160, 32)` and ignores the result. Executed (`eth_simulateV1`, block 26,438,999): with a recovery that cannot finish in 3,000 gas, `proveInvalidWitness` on an honestly signed transaction emits `FraudCommitted(9, 8, 150)` and pays the caller 0.25 ETH; today it finds nothing.
- 3,072-gas wallets (factory `0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59`): bytecode pc 187–207 `PUSH2 0x0c00`, `STATICCALL` to `0x01`, `INVALID` on failure. Executed: transaction `0x0323ebe3274b24b64ec6193d93729c9a37fecb1371d921cfd6d7dc98628dbd0f` (block 26,432,607) succeeds today with 64,082 gas, as its receipt says; under EIP-8151 it hits `INVALID` and uses the whole 200,000.

## Impact and exposure

No row holds value at block 26,438,999.

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Immutable code cannot change: holders move what the contracts hold before activation. Where an owner can withdraw or upgrade, the owner acts.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [fuel-v1-fixed-gas-witness-recovery](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/fuel-v1-fixed-gas-witness-recovery.md), [unidentified-cd097b8d-wallets-fixed-gas-recovery](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-cd097b8d-wallets-fixed-gas-recovery.md).
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
