---
id: fuel-v1-fixed-gas-witness-recovery
title: "Fuel v1: once EIP-8151 is active, anyone can roll back an honest rollup block and take half of its producer's bond, and two real fraud proofs stop working"
project: fuel
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  implementation: null
  name: Fuel (v1.1.0 rollup contract, Yul+, not verified)
  upgradeable: "no"
  admin: "none: no upgrade function in the source; the operator 0xfa990ea3cc8f1ec066986477edf457ffbad6e39c is a constructor value"
  value_usd: 18
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-16
  txs_30d: 6
families: []
fix:
  layer: offchain
  who_acts: "users and the operator: authorise rollup transactions with commitWitness (a mainnet call) instead of a signature, or stop using the system; Fuel Labs can say so. The contract cannot change"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (source and bytecode read, simulation on an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed-gas list of 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Fuel v1 is an optimistic rollup on mainnet. It checks the signature of a rollup transaction only when someone files
a fraud proof, and it gives that check exactly 3,000 gas without looking at whether the call worked. Under EIP-8151 a
recovery that succeeds costs 3,200 or 6,100 gas, so the check returns "no signer" for every valid signature. An
honest block then looks fraudulent: anyone can roll it back and is paid half of the producer's 0.5 ETH bond. Two real
fraud proofs also stop working. Nobody has to migrate an account for this. The system is almost unused and holds
about USD 18, which is why this is rated LOW.

## Mechanism

Pattern PQ-14, with a wrong verdict instead of a revert.

- `ecrecover` in `Witness.yulp` calls `0x01` with a literal 3,000 gas, ignores the call's result, and returns the
  output word, which it cleared before. A failed call gives zero.
- `proveInvalidWitness` treats zero as fraud ("null-witness"). Fraud sets the rollup tip to the block before,
  deletes the block's commitment and sends half the bond to the caller.
- Before `proveInvalidWitness` judges a transaction, it re-checks the witness of every earlier transaction whose
  transfer or HTLC output is spent, with a `require`. `proveInvalidSum` does the same for the transaction itself.
  When a recovery cannot succeed, these proofs revert: a forged spend, or a transaction that pays out more than it
  takes in, can no longer be proven when signed transactions are involved.
- Signatures are not checked when a root or a block is committed, and `withdraw` checks only inclusion and finality.

## Evidence

Source: `github.com/FuelLabs/fuel-v1-contracts` at commit `2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22`.

- CHECKED (source, `src/Witness.yulp` lines 137 to 144):

  ```
      // Clear memory ECRecover precompile return.
      mstore(160, 0)

      // Here we call ECRecover precompile at address 0x01, we allow it to fail.
      let result := call(3000, 1, 0, 0, 128, 160, 32)

      // Return the result RCRecover address.
      account := mload(160)
  ```

- CHECKED (source, `src/provers/InvalidWitness.yulp` lines 21 to 31):

  ```
      let recoveredWitness := TransactionProof.input.recoverWitness(transactionProof)

      // Ensure that the recovered witness is not null, null can never be a witness.
      assertOrFraud(
        neq(
          recoveredWitness,
          0
        ),
        error"null-witness",
        transactionProof
      )
  ```

- CHECKED (source, `src/Fraud.yulp` lines 112 to 132): on fraud, `sstore(Storage.BlockTip, sub(fraudBlockHeight, 1))`,
  the block's commitment is set to zero, and `transfer(div(bondSize, 2), 0, caller())`.
- CHECKED (source): the reverting checks are `verifyWitness` in `src/verifiers/Witness.yulp` (four `require`, lines
  32, 43, 67, 79), called from `src/verifiers/Inputs.yulp` lines 35 and 157 and from `src/provers/InvalidSum.yulp`
  line 220.
- CHECKED (deployed code at block 26,438,999): the contract is not verified. The code pushes 3,000 exactly once, at
  pc 10865, directly before a `CALL` whose result is popped. The nine constructor values at the end of the code
  equal the repository's deployment script (`config/verify.js`): operator, 93,046 blocks to finality, 33,230 blocks
  submission delay, 3,323 blocks penalty, bond 0.5 ETH, "Fuel", "1.1.0", chain 1, and the genesis hash. All 8 event
  topics of the Fuel source are in the code. The repository names this address as its mainnet deployment.
- CHECKED (executed, `eth_simulateV1` on a reth archive node, on top of block 26,438,999; nothing was sent). Three
  simulated blocks: a new user deposits 1 ETH and commits a root with one transaction that spends the deposit and
  carries the user's own valid signature; the operator commits rollup block 9 with the 0.5 ETH bond; a third
  address calls `proveInvalidWitness` on that transaction.

  | Run | `proveInvalidWitness` | Rollup tip | Paid to the caller |
  |---|---|---|---|
  | The precompile as it is today | runs, finds nothing | stays 9 | 0 |
  | A recovery cannot finish within 3,000 gas | emits `FraudCommitted(9, 8, 150)` | 8 | 0.25 ETH |

  Before simulating, the script's hashing was checked against the real rollup block 8: commitment hash, Merkle
  root, root id and block commitment all match what is stored on mainnet.
- What the simulation models: the gas failure is produced by a contract placed at `0x01` that needs more than
  3,000 gas (the real precompile is moved aside), not by a client that implements the EIP's price; the ten-block
  wait after `commitFraudHash` is replaced by writing the commitment into storage; the deposit and the gas money
  are given by state overrides.
- CHECKED (logs of the contract from its creation in block 11,787,727 to block 26,438,999): 12 deposits, 12 roots,
  10 blocks, 8 withdrawals, 1 fraud proof (`proveInvalidTransaction`, block 14,747,989). In October and November
  2026 one address made two deposits of 1 wei, two roots, rollup block 8 with the bond, and one withdrawal. Both
  roots hold a transaction with a signature witness.
- CHECKED (balances at block 26,438,999): 0.000001 ETH, 11 USDC, 6.01 DAI, 1 USDT.
- INFERRED (source read, not executed): the two proofs that revert. They need two chained rollup transactions built
  by hand.
- INFERRED: fraud code 150 is "null-witness". The compiled list of codes is not public. The source declares that
  error first in this prover, and an earlier run with a wrongly built proof gave 152 for a wrong signer.

## Impact and exposure

- One contract, not upgradeable, no owner.
- Who loses: the producer of any block that is not final and holds a signed transaction spending a deposit (0.25
  ETH goes to the caller, the other 0.25 ETH stays in the contract because the block's commitment is gone); every
  user with a transaction or a withdrawal in a rolled-back block, who must wait for a new block; and, if the two
  inferred effects hold, anyone whose output was created by a signed transaction.
- Blocks that are already final are not affected. Transactions authorised by `commitWitness` are not affected.
- Value: about USD 18 in the contract. Activity: six transactions in the last 30 days, from one address.
- Rated LOW by the study's rule. By consequence alone it would be the highest class (an honest party is punished,
  and nobody can change the contract). The system is dormant and holds under USD 50,000.

## Remediation

- Nothing can be changed in the contract.
- Users and the operator can avoid signatures: a transaction authorised by `commitWitness` never reaches the
  precompile.
- The project's repository is archived (last push in April 2021). A note to its remaining users, and to anyone who
  still runs a producer, is what is left.
- The same protocol-side remark as for every finding of this pattern: 3,000 gas is the amount old code forwards.

## History

- 2026-11-19: reported from study `eip-8151-impact`. The fixed gas was found by a scan of every unique runtime
  code. The contract's source is not on Sourcify; it was read from the project's public repository, matched to the
  deployed code as described, and the first effect was executed in a simulation.
