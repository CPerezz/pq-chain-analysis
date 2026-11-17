---
id: linea-blob-kzg
title: "Linea: LineaRollup accepts L2 data only through KZG blob openings; with the KZG setup trapdoor an operator key can post blobs that do not hold the proven L2 data, withholding the state behind $46M of bridged funds"
project: linea
status: confirmed
severity: MEDIUM
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0xd19d4b5d358258f05d7b411e21a1460d11b0876f"
  implementation: "0x052b73d934e9412045bf731574463fd026d74645"
  name: TransparentUpgradeableProxy → LineaRollup
  upgradeable: "yes"
  admin: "ProxyAdmin 0xf5058616517c068c7b8c7ebc69ff636ade9066d6, owned by TimeLock 0xd6b95c960779c72b8c6752119849318e5d550574 (min delay 0; proposer/executor Security Council Safe 0x892bb7eed71efb060ab90140e7825d8127991dd3, 5 of 9), read at block 26431459"
  value_usd: 46177353
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 2657
families: []
fix:
  layer: contract-upgrade
  who_acts: "Linea Security Council Safe 0x892bb7eed71efb060ab90140e7825d8127991dd3 (5 of 9), through TimeLock 0xd6b95c960779c72b8c6752119849318e5d550574 (min delay 0) and ProxyAdmin 0xf5058616517c068c7b8c7ebc69ff636ade9066d6, upgrades LineaRollup to restore calldata data availability (submitDataAsCalldata, removed at block 24778478); post-quantum blobs need an Ethereum protocol change"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source of 0x052b73d9, cast reads at block 26431459, Blockscout
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [linea-plonk-verifier-bn254]
---

## Summary

Linea's L1 rollup contract accepts each batch of L2 data only if a KZG opening of the EIP-4844 blob verifies at the
point-evaluation precompile (PQ-8). With the KZG ceremony trapdoor, whoever holds an operator key (two EOAs, which a
quantum attacker can also take) can open a blob to any value, so the rollup accepts blobs that do not contain the data
the SNARK proved and the L2 state cannot be rebuilt from L1: data withholding, not theft, behind $46.2M (LineaRollup's
19,599 ETH plus the TokenBridge, 2026-11-17). The current implementation has no calldata path, but Linea had one
(`submitDataAsCalldata`) until block 24,778,478, and the Security Council can upgrade LineaRollup with no delay.
Rated MEDIUM, step 4: the fix is an admin upgrade back to calldata data availability, no protocol change needed.

## Mechanism

- `submitBlobs(BlobSubmission[], parentShnarf, finalBlobShnarf)` in `Eip4844BlobAcceptor` (LineaRollup implementation
  `0x052b73d9…`) is `onlyRole(OPERATOR_ROLE)`. For each blob it takes `blobhash(i)`, sets the evaluation point
  `z = keccak(snarkHash, blobhash)`, and calls `_verifyPointEvaluation`, which `staticcall`s precompile `0x0a` with
  (versioned hash, z, claim y, kzgCommitment, kzgProof) and reverts unless it returns 4096 / BLS modulus
  (`source-excerpts.md`, `Eip4844BlobAcceptor.sol` lines 107–135).
- The accepted `(snarkHash, finalStateRootHash, z, y)` go into the shnarf chain. `finalizeBlocks` (also
  `OPERATOR_ROLE`) later checks a PLONK proof whose public input commits to these shnarfs; the proof shows that the
  executed L2 data evaluates to y at z. The KZG opening is the only link between that data and the blob actually posted.
- A false opening therefore lets the posted blob differ from the proven data: state roots finalize, but the data to
  reconstruct them is not on L1. The (z, y) pair does enter proof verification, but only as a binding to the blob; the
  SNARK still proves an honest execution of the data the prover used, so a false opening cannot release funds by
  itself. Only `OPERATOR_ROLE` can submit blobs, so the attacker needs an operator key (or is the operator).
- Fallback: none in the current implementation (`submitBlobs` is the only submit function). Implementations
  `0x07ddce60…` (from block 21,415,497) and `0x04728bf7…` (from block 24,563,176) also had
  `submitDataAsCalldata`, which committed the data by hash with no KZG; the upgrade to `0xe6869769…` at block
  24,778,478 removed it ([`implementation-history.md`](#linearollup-implementation-history-and-calldata-data-availability)).
- Pattern PQ-8 (KZG blob commitment opening, trigger: trusted setup).

## Evidence

- CHECKED (Sourcify full source of implementation `0x052b73d934e9412045bf731574463fd026d74645`, read 2026-11-17):
  `submitBlobs`/`_submitBlobs`/`_verifyPointEvaluation` as above; `finalizeBlocks` and `submitBlobs` require
  `OPERATOR_ROLE`; no other data-submission function.
- CHECKED (cast at block 26,431,459): EIP-1967 implementation `0x052b73d9…`, admin `0xf5058616…`; ProxyAdmin `owner()`
  = TimeLock `0xd6b95c96…` (Blockscout name `TimeLock`, `getMinDelay()` = 0); Safe `0x892bb7ee…` holds the TimeLock's
  PROPOSER and EXECUTOR roles, threshold 5 of 9 owners; on LineaRollup the Safe holds `DEFAULT_ADMIN_ROLE` and the
  TimeLock holds `VERIFIER_SETTER_ROLE` ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-blob-kzg/escrow.json)).
- CHECKED (cast at block 26,431,459): `OPERATOR_ROLE` is held by EOAs `0x46d2f319fd42165d4318f099e143dea8124e9e3e`
  (sends `submitBlobs`) and `0x52ff08f313a00a54e3beffb5c4a7f7446efb6754` (sends `finalizeBlocks`); both have no code.
- CHECKED (cast + Blockscout, block 26,431,459): LineaRollup holds 19,599.4 ETH ($35.57M); TokenBridge
  `0x051f1d88f0af5763fb888ec4378b4d8b29ea3319` (its `messageService()` = LineaRollup) holds $10.61M in ERC-20s
  (USDT $6.9M, WBTC $1.9M, wstETH $1.5M, …; first Blockscout page, sorted by value); the legacy USDC bridge
  `0x504a3303…` holds $36; YieldManager `0xeb63cabd…` holds 0.
- CHECKED (Xatu, any function): 2,657 transactions 2026-10-16 to 2026-11-16, last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-blob-kzg/activity.json)); Blockscout shows `submitBlobs` every few hours up to
  block 26,430,202.
- CHECKED (precompile trace, 12 months to March 2026): 8,269 transactions calling point evaluation
  (`curated_contracts.csv`, `txs_y1`).
- CHECKED (Blockscout `Upgraded` logs and verified ABIs, read 2026-11-17): implementation history; `submitDataAsCalldata`
  present in `0x07ddce60…` and `0x04728bf7…`, absent from `0xe6869769…`, `0x59290394…` and the current `0x052b73d9…`.
- INFERRED: a false opening alone cannot finalize a false state root; that needs a forged SNARK as well
  (`linea-plonk-verifier-bn254`). Also INFERRED: restoring calldata DA needs a prover circuit that accepts the calldata
  commitment again; whether the current circuit does was not checked.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd19d4b5d…` TransparentUpgradeableProxy → LineaRollup | yes | $46.2M (escrow: own ETH + TokenBridge) | 2026-11-16 | 2,657 |

- Escrow: LineaRollup `0xd19d4b5d…` (19,599 ETH, $35.57M) and TokenBridge `0x051f1d88…` ($10.61M), together
  $46,177,353 at 2026-11-17. Both release funds on L2→L1 messages anchored by `finalizeBlocks`.
- Worst effect of this mechanism alone: state data withheld (funds stuck until the rollup's operators or Security
  Council intervene); with the SNARK forgery in the sibling finding, the escrow can be drained.
- The draft listed a family of 148 contracts; the census groups by proxy bytecode, and these 148 share LineaRollup's
  TransparentUpgradeableProxy build (the listed code `0x0c6c7386…` is another member's implementation, a RedStone
  `EthereumMultiFeedAdapterWithoutRoundsV3`). They are not LineaRollup deployments; the entry was removed.
- Siblings: another LineaRollup deployment, proxy `0x2f3c205613d9451f88e19e011ed23775afe00c41` (deployer 0xbbef10ce,
  not Linea mainnet), is covered by `rarimo-blob-kzg`.

## Remediation

- Fallback without a protocol change: the Security Council upgrades LineaRollup to accept L2 data as calldata committed
  by a hash, as `submitDataAsCalldata` did until block 24,778,478 (with a matching prover circuit), at much higher cost
  per batch. This removes the KZG dependency.
- Who acts: Linea Security Council Safe `0x892bb7ee…` (5 of 9) through TimeLock `0xd6b95c96…` (0 delay) and ProxyAdmin
  `0xf5058616…`. Protocol change: not needed for the calldata fallback; keeping blob data availability post-quantum
  needs an Ethereum change (hash- or FRI-based blob commitments).
- Moving `OPERATOR_ROLE` from EOAs to accounts with post-quantum authorisation would keep an outside attacker from using
  the trapdoor here; it does not stop a malicious operator.
- Users cannot act on this path themselves beyond withdrawing.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review12): HIGH -> HIGH, step 4: KZG precompile dependency that only a protocol change replaces. Impact funds-loss -> funds-locked (a false opening withholds data; theft also needs the SNARK forgery). Admin chain read from storage (TimeLock 0 delay, Security Council Safe 5 of 9); value basis held -> escrow ($46.2M: LineaRollup ETH + TokenBridge); removed the unrelated TransparentUpgradeableProxy family; related to linea-plonk-verifier-bn254.
- 2026-11-17 review (Review12), after the KZG rubric change: HIGH -> MEDIUM, step 4: the admin can switch to calldata data availability by upgrade (Security Council through a 0-delay TimeLock; `submitDataAsCalldata` existed until block 24,778,478), so a protocol change is not the only fix. Impact funds-locked: only `OPERATOR_ROLE` submits blobs and a false opening does not make the SNARK release funds. fix.layer protocol -> contract-upgrade, protocol_change required -> not-needed.

# Source excerpts: linea-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd19d4b5d358258f05d7b411e21a1460d11b0876f` — TransparentUpgradeableProxy (verified source via sourcify)

## Implementation `0x052b73d934e9412045bf731574463fd026d74645` — LineaRollup (verified source via sourcify)

### `src/rollup/LineaRollupBase.sol`

```solidity
   45    /// @notice The empty hash value.
   46    bytes32 internal constant EMPTY_HASH = 0x0;
   47  
   48    /// @dev The BLS Curve modulus value used.
   49    uint256 internal constant BLS_CURVE_MODULUS =
   50      52435875175126190479447740508185965837690552500527637822603658699938581184513;
   51  
   52    /// @dev The well-known precompile address for point evaluation.
   53    address internal constant POINT_EVALUATION_PRECOMPILE_ADDRESS = address(0x0a);
   54  
   55    /// @dev The expected point evaluation return data length.
   56    uint256 internal constant POINT_EVALUATION_RETURN_DATA_LENGTH = 64;
   57  
   58    /// @dev The expected point evaluation field element length returned.
   59    uint256 internal constant POINT_EVALUATION_FIELD_ELEMENTS_LENGTH = 4096;
   60  
   61    /// @notice This is the ABI version and not the reinitialize version.
   62    string private constant _CONTRACT_VERSION = "8.0";
   63  
  ...
  387      if (_finalizationData.finalForcedTransactionNumber > 0 && finalForcedTransactionRollingHash == EMPTY_HASH) {
  388        revert MissingRollingHashForForcedTransactionNumber(_finalizationData.finalForcedTransactionNumber);
  389      }
  390  
  391      _verifyProof(
  392        _computePublicInput(
  393          _finalizationData,
  394          lastFinalizedShnarf,
  395          _finalizeBlocks(_finalizationData, lastFinalizedBlockNumber, finalForcedTransactionRollingHash),
  ...
  705     * @param _publicInput The computed public input hash cast as uint256.
  706     * @param _verifierAddress The address of the proof type verifier contract.
  707     * @param _proof The proof to be verified with the proof type verifier contract.
  708     */
  709    function _verifyProof(uint256 _publicInput, address _verifierAddress, bytes calldata _proof) internal {
  710      uint256[] memory publicInput = new uint256[](1);
  711      publicInput[0] = _publicInput;
  712  
  713      (bool callSuccess, bytes memory result) = _verifierAddress.call(
  ...
```

### `src/rollup/dataAvailability/Eip4844BlobAcceptor.sol`

```solidity
  107      bytes memory _kzgCommitment,
  108      bytes memory _kzgProof
  109    ) internal view {
  110      assembly {
  111        _dataEvaluationPoint := mod(_dataEvaluationPoint, BLS_CURVE_MODULUS)
  112      }
  113  
  114      (bool success, bytes memory returnData) = POINT_EVALUATION_PRECOMPILE_ADDRESS.staticcall(
  115        abi.encodePacked(_currentDataHash, _dataEvaluationPoint, _dataEvaluationClaim, _kzgCommitment, _kzgProof)
  116      );
  117  
  118      if (!success) {
  119        revert PointEvaluationFailed();
  120      }
  121  
  122      if (returnData.length != POINT_EVALUATION_RETURN_DATA_LENGTH) {
  123        revert PrecompileReturnDataLengthWrong(POINT_EVALUATION_RETURN_DATA_LENGTH, returnData.length);
  124      }
  125  
  126      uint256 fieldElements;
  127      uint256 blsCurveModulus;
  128      assembly {
  129        fieldElements := mload(add(returnData, 0x20))
  130        blsCurveModulus := mload(add(returnData, POINT_EVALUATION_RETURN_DATA_LENGTH))
  131      }
  132      if (fieldElements != POINT_EVALUATION_FIELD_ELEMENTS_LENGTH || blsCurveModulus != BLS_CURVE_MODULUS) {
  133        revert PointEvaluationResponseInvalid(fieldElements, blsCurveModulus);
  134      }
  135    }
  136  }
  ...
```

# LineaRollup implementation history and calldata data availability

`Upgraded(address)` logs of proxy `0xd19d4b5d358258f05d7b411e21a1460d11b0876f` (Blockscout logs API, read 2026-11-17),
and the `submit*` functions in each implementation's verified ABI (Blockscout `smart-contracts` endpoint).

| Block | Implementation | submit functions |
|---|---|---|
| 17,677,070 | 0xe8f627df6cb02e415b2e6d6e112323bd269b4706 | not checked |
| 17,699,095 | 0x4c8d4ce72afaa417d1f7e833725fdb4e793cd6b3 | not checked |
| 17,871,545 | 0xb32c3d0ddb0063ffb15e8a50b40cc62230d820b3 | not checked |
| 19,217,961 | 0xaa4b3a9515c921996abe7930bf75eff7466a4457 | not checked |
| 19,518,028 | 0x934dd4c63e285551cecef8459103554d0096c179 | not checked |
| 20,025,435 | 0x53fc68bffc03d17804e5a901de42d1eef2e64562 | not checked |
| 21,072,224 | 0x1825242411792536469cbb5843fd27ce3e9e583a | not checked |
| 21,415,497 | 0x07ddce60658a61dc1732cacf2220fce4a01c49b0 | submitBlobs, submitDataAsCalldata |
| 24,563,176 | 0x04728bf704a716c26f9ef4085013b760ac885631 | submitBlobs, submitDataAsCalldata |
| 24,778,478 | 0xe68697690e8ff196a6abb3e1385156d87df85332 | submitBlobs only |
| 25,544,952 | 0x59290394ddc1cf84e671701a929710643c343530 | submitBlobs only |
| 25,881,432 | 0x052b73d934e9412045bf731574463fd026d74645 (current) | submitBlobs only |

The calldata path (`submitDataAsCalldata`) existed until block 24,778,478 and was removed in the upgrade at that
block. The current implementation accepts data only through `submitBlobs` (KZG point evaluation).
