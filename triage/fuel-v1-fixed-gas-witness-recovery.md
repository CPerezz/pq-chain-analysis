---
id: fuel-v1-fixed-gas-witness-recovery
title: "Fuel v1: under EIP-8151 anyone can roll back an honest rollup block and take half its producer's bond"
project: fuel
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  implementation: null
  name: Fuel (v1.1.0 rollup, Yul+, not verified)
  upgradeable: "no"
  admin: "none (operator 0xfa990ea3cc8f1ec066986477edf457ffbad6e39c is a constructor value)"
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-16
  txs_30d: 6
families: []
fix:
  layer: offchain
  who_acts: "users and operator: authorise with commitWitness instead of signatures; the contract cannot change"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (source and bytecode read, simulated on an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed-gas list"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

Fuel v1 gives `ecrecover` exactly 3,000 gas and ignores failure. Under EIP-8151 every valid signature then
recovers to zero, which `proveInvalidWitness` treats as fraud: anyone can roll back an honest block and is paid half
the producer's 0.5 ETH bond. Immutable; dormant.

## Mechanism

PQ-14 with a wrong verdict. Two other proofs (`verifyWitness` `require`s) revert instead, so real fraud involving
signed transactions can no longer be proven.

## Evidence

- Source `FuelLabs/fuel-v1-contracts@2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22`, `src/Witness.yulp` L137–144:
  `let result := call(3000, 1, 0, 0, 128, 160, 32)`, result unused; `src/provers/InvalidWitness.yulp` L21–31: zero
  is fraud ("null-witness"). Deployed code pushes 3,000 once (pc 10865); its constructor values equal
  `config/verify.js`.
- Executed (`eth_simulateV1`, top of block 26,438,999): deposit, a root with one validly signed transaction, block 9
  with the bond, then `proveInvalidWitness` from a third address. Today: nothing found. With a recovery that cannot
  finish in 3,000 gas (a contract at `0x01`, not a client with the EIP's price): `FraudCommitted(9, 8, 150)`, tip
  9 → 8, caller paid 0.25 ETH.

## Impact and exposure

Producers of non-final blocks lose half the bond; users in rolled-back blocks wait. Holds USD 18; 6 transactions in
30 days.

## Remediation

None in the contract. Signing with `commitWitness` avoids the precompile.

## History

- 2026-11-19: reported from study `eip-8151-impact`.
- 2026-11-19: moved to `triage/`; proposed rating LOW → CRITICAL: value and activity no longer lower a rating.
