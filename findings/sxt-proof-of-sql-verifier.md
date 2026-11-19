---
id: sxt-proof-of-sql-verifier
title: "Space and Time: a recovered BN254 setup trapdoor lets anyone fulfil zkPay SQL queries routed to PoSQLVerifier with false results; the path has been idle since 2025-08 and releases no funds to the fulfiller"
project: space-and-time
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: unknown
alternative: configurable-verifier
role: core
contracts:
- address: "0x99f5bed89c638d8f67f7c132a18da349ac04ed18"
  implementation: null
  name: PoSQLVerifier
  upgradeable: "no"
  admin: none over verification (immutable; OWNER can only withdraw ETH); each zkPay query names its custom-logic verifier, so requesters choose another
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-08-19
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Space and Time deploys a hash-based Proof of SQL verifier; zkPay query requesters (client contracts) name it as `customLogicContractAddress` instead of 0x99f5bed89c638d8f67f7c132a18da349ac04ed18
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sxt-proof-of-sql-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`PoSQLVerifier` (`0x99f5bed8…ed18`) is the zkPay "custom logic" that checks a Space and Time Proof of SQL result
with HyperKZG openings on BN254 (pairing precompile) before ZKPay (`0x27d4d2af…d450`) passes the result to the
requesting client's callback (PQ-7). A quantum attacker who recovers the setup trapdoor could fulfil queries with
false results; what that is worth depends on the client contracts, which were not identified. The fulfiller gains no
payment (the query fee goes to Space and Time's fixed payout address), the verifier holds nothing, and the path has
not been used since 2025-08-19. Rated LOW, step 1 (no activity in 12 months, nothing held).

## Mechanism

- `ZKPay.fulfillQuery(queryHash, queryRequest, queryResult)` (`src/ZKPay.sol` 162–200, permissionless) checks the
  stored query, calls `ICustomLogic(queryRequest.customLogicContractAddress).execute(queryRequest, queryResult)`,
  then `zkPayCallback` on the client with the returned result, and settles the escrowed fee to the custom logic's
  payout address.
- `PoSQLVerifier.execute` (`src/PoSQLVerifier.sol` 396–412) → `verify` (383–393) → `Verifier.__verify` from
  `sxt-proof-of-sql` 0.100.10 (`Verifier.post.sol`, HyperKZG with `ec_pairing_x2`, lines 139–146, 709).
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](#source-excerpts-sxt-proof-of-sql-verifier).

## Evidence

- CHECKED (verified source, Sourcify): `PoSQLVerifier` and `ZKPay` implementation `0x8c81a00f…c48b`, lines above.
- CHECKED (on-chain read at block 26,431,655): `getPayoutAddressAndFee()` = (`0xad45b384…5c75`, 0.5e18); no ETH
  held; ZKPay is a TransparentUpgradeableProxy (admin `0xce1e38a8…faa6`, owned by EOA `0x2b1415f2…2c98`) holding 102
  USDC and 100 SXT of pending query payments ([`consumer.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sxt-proof-of-sql-verifier/consumer.json)).
- CHECKED (precompile trace): 519 transactions with BN254 calls, blocks 22,485,398–23,176,777 (last 2025-08-19);
  8 sampled are `ZKPay.fulfillQuery` sent by `0x5d067e94…ae80`.
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/sxt-proof-of-sql-verifier/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x99f5bed8…` PoSQLVerifier | no | 0 | 2025-08-19 | 0 |

- No escrow is released to a fulfiller: ZKPay's 102 USDC of pending payments settle to the verifier's payout
  address whatever the result. The exposure is whatever client contracts do in `zkPayCallback` with the result; the
  clients were not identified, so `impact` is unknown.
- `usd_tx_y1` (USD 256) is the year's query payments.

## Remediation

- Post-quantum replacement: a Proof of SQL verifier with a hash-based commitment scheme (FRI/WHIR instead of
  HyperKZG on BN254).
- Who must act: Space and Time (deploys it); zkPay clients name it as `customLogicContractAddress` in new queries. No
  protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-19) and nothing held).
- 2026-11-17 review (Review05): LOW kept, step 1: last use 2025-08-19 and the verifier holds nothing. Consumer traced
  to ZKPay `0x27d4d2af…`, whose escrowed fees go to Space and Time's payout address, not the fulfiller; `impact`
  funds-loss -> unknown (client callbacks not identified).
- 2026-11-19: LOW -> MEDIUM, step 1 removed (dormancy no longer lowers a rating); step 4 gives MEDIUM: a new verifier the consumer points at.

# Source excerpts: sxt-proof-of-sql-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x99f5bed89c638d8f67f7c132a18da349ac04ed18` — PoSQLVerifier (verified source via sourcify)

### `dependencies/sxt-proof-of-sql-0.100.10/solidity/src/base/Errors.sol`

```solidity
   61      error InvalidECAddInputs();
   62      /// @notice Error thrown when the inputs to the ECMUL precompile are invalid.
   63      error InvalidECMulInputs();
   64      /// @notice Error thrown when the inputs to the ECPAIRING precompile are invalid.
   65      error InvalidECPairingInputs();
   66      /// @notice Error thrown when a boolean literal is invalid.
   67      error InvalidBoolean();
   68      /// @notice Error code for commitment array having odd length which is impossible
   69      /// since each commitment is 2 elements.
  ...
   78      error HyperKZGInconsistentV();
   79      /// @notice Error thrown when the HyperKZG proof has an empty x point.
   80      error HyperKZGEmptyPoint();
   81      /// @notice Error thrown when the HyperKZG proof fails the pairing check.
   82      error HyperKZGPairingCheckFailed();
   83      /// @notice Error thrown when the produces constraint degree is higher than the provided proof.
   84      error ConstraintDegreeTooHigh();
   85      /// @notice Error thrown when the case literal in a switch statement is incorrect.
   86      error IncorrectCaseConst();
  ...
```

### `dependencies/sxt-proof-of-sql-0.100.10/solidity/src/verifier/Verifier.post.sol`

```solidity
  135                  ec_mul(args_ptr)
  136              }
  137              function exclude_coverage_stop_ec_mul_assign() {} // solhint-disable-line no-empty-blocks
  138              // IMPORTED-YUL ../base/ECPrecompiles.pre.sol::ec_pairing_x2
  139              function exclude_coverage_start_ec_pairing_x2() {} // solhint-disable-line no-empty-blocks
  140              function ec_pairing_x2(args_ptr) -> success {
  141                  if iszero(staticcall(ECPAIRINGX2_GAS, ECPAIRING_ADDRESS, args_ptr, WORDX12_SIZE, args_ptr, WORD_SIZE)) {
  142                      err(ERR_INVALID_EC_PAIRING_INPUTS)
  143                  }
  144                  success := mload(args_ptr)
  145              }
  146              function exclude_coverage_stop_ec_pairing_x2() {} // solhint-disable-line no-empty-blocks
  147              // IMPORTED-YUL ../base/Errors.sol::err
  148              function exclude_coverage_start_err() {} // solhint-disable-line no-empty-blocks
  149              function err(code) {
  150                  mstore(0, code)
  ...
  703                  mstore(add(scratch, WORDX8_SIZE), VK_TAU_HX_IMAG)
  704                  mstore(add(scratch, WORDX9_SIZE), VK_TAU_HX_REAL)
  705                  mstore(add(scratch, WORDX10_SIZE), VK_TAU_HY_IMAG)
  706                  mstore(add(scratch, WORDX11_SIZE), VK_TAU_HY_REAL)
  707                  if iszero(ec_pairing_x2(scratch)) { err(ERR_HYPER_KZG_PAIRING_CHECK_FAILED) }
  708              }
  709              function exclude_coverage_stop_verify_hyperkzg() {} // solhint-disable-line no-empty-blocks
  710              // IMPORTED-YUL ../proof_exprs/ColumnExpr.pre.sol::column_expr_evaluate
  711              function exclude_coverage_start_column_expr_evaluate() {} // solhint-disable-line no-empty-blocks
  ...
```

### `src/PoSQLVerifier.sol`

```solidity
  379          __tableLengths = tableLengths;
  380          __commitments = commitments;
  381      }
  382  
  383      function verify(QueryBody calldata queryBody, ResultBody calldata queryResultStruct) internal view {
  384          (
  385              bytes calldata __result,
  386              bytes calldata __plan,
  387              bytes calldata __proof,
  ...
  405              queryBody := add(query.offset, 0x20)
  406              queryResultStruct := add(queryResult.offset, 0x20)
  407          }
  408  
  409          verify(queryBody, queryResultStruct);
  410  
  411          return queryResultStruct.result;
  412      }
  413  
  ...
```
