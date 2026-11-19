---
id: vizing-fflonk-verifier
title: "Vizing (Polygon CDK validium): a quantum attacker who recovers the fflonk setup trapdoor can prove false Vizing state and drain its bridge, which holds about $165"
project: vizing
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x985e89135fb4968bca0db46422dc1ed31b985d52"
  implementation: null
  name: FflonkVerifier
  upgradeable: "no"
  admin: "none on the verifier; it is an immutable in Vizing's CDKValidium implementation 0xe2c688df3f4569d0f510553f94b47eb32cf9d177 behind proxy 0x283286888a834a60fb0ded64bfbc246ab175950b, upgradeable by ProxyAdmin 0xe9175f66c79664114a7aa8c86997b74c5775e1af owned by CDKValidiumTimelock 0x1ef0eff8cdb4df5ced75a3afd7c6e71e03568cac (24 h; proposer EOA 0x8ae7370cdbd0382d82e171dee7186c65348df287); read at block 26431457"
  value_usd: 165
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-03-25
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "Vizing: timelock proposer 0x8ae7370cdbd0382d82e171dee7186c65348df287 schedules, executor 0x7932a59d1b92d4be1b7f968e24157cde7a85a35b executes, an upgrade of proxy 0x283286888a834a60fb0ded64bfbc246ab175950b to an implementation with a post-quantum verifier, through CDKValidiumTimelock 0x1ef0eff8cdb4df5ced75a3afd7c6e71e03568cac"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/vizing-fflonk-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/vizing-fflonk-verifier/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

This fflonk verifier on BN254 checks the validity proofs of Vizing Mainnet (chain id 28518), a standalone Polygon CDK
validium (PQ-7). A quantum attacker who recovers the setup trapdoor can prove a false state and exit root and claim
from Vizing's L1 bridge, which holds about $165; the chain stopped sequencing on 2026-03-25. Rated LOW: an upgrade
through Vizing's timelock would fix it (MEDIUM, step 4), lowered by step 5 (escrow under $50k).

## Mechanism

- `CDKValidium._verifyAndRewardBatches` (CDKValidium.sol l.761 onward) calls `rollupVerifier.verifyProof(proof,
  [inputSnark])` (l.823) for `verifyBatchesTrustedAggregator` (l.715, trusted aggregator only) and `verifyBatches`
  (l.642, anyone once `trustedAggregatorTimeout` has passed); a verified batch sets the new state root and local exit
  root in the global exit root manager, against which the bridge pays `claimAsset`.
- `rollupVerifier` is `immutable` in the CDKValidium implementation (l.152, set in the constructor l.394), so changing
  the verifier means upgrading the validium proxy to a new implementation.
- `FflonkVerifier.verifyProof` (`0x9121da8a`): snarkJS fflonk verifier using `ecAdd`, `ecMul` and the pairing
  precompile.

Pattern PQ-7. Excerpts: [`source-excerpts.md`](#source-excerpts-vizing-fflonk-verifier).

## Evidence

- CHECKED (trace of tx `0xbd34eb33…`, block 24,732,176): trusted aggregator `0xdc543a9c…` -> proxy `0x28328688…`
  `verifyBatchesTrustedAggregator` -> delegatecall CDKValidium `0xe2c688df…` -> `0x985e8913….verifyProof` -> BN254
  precompiles ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/vizing-fflonk-verifier/review-reads.json)).
- CHECKED (Sourcify verified source of CDKValidium `0xe2c688df…`, read 2026-11-17): the lines above.
- CHECKED (on-chain at block 26,431,457): proxy `0x28328688…` `networkName()` "Vizing Mainnet", `chainID()` 28518,
  `trustedSequencerURL()` https://rpc.vizing.com, `rollupVerifier()` = this verifier, `lastBatchSequenced()` =
  `lastVerifiedBatch()` = 69,633, `bridgeAddress()` `0x44db454c…`; EIP-1967 admin = ProxyAdmin `0xe9175f66…`, whose
  `owner()` is CDKValidiumTimelock `0x1ef0eff8…` (`getMinDelay()` 86,400 s); timelock roles from RoleGranted logs
  (block 19,474,791): proposer `0x8ae7370c…`, executor `0x7932a59d…`, admin `0xcfaa0033…` (all EOAs).
- CHECKED (Blockscout, 2026-11-17): bridge `0x44db454c…` (PolygonZkEVMBridge, same ProxyAdmin) holds 0.0769 ETH,
  20 USDC and 6 USDT, about $165 (ETH at $1,811.62); its and the validium's last transactions are on 2026-03-25.
- CHECKED (precompile trace to March 2026): 206 BN254 verifications in the year
  (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Blockscout): CDKValidium and the verifier were created by `0x661d94814db578ddea934d3b438f588f397a72a3`.

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x985e8913…` FflonkVerifier | no | $165 (bridge `0x44db454c…`) | 2026-03-25 | 0 |

The verifier holds nothing; the escrow is Vizing's L1 bridge. The data-availability committee (`0xdd9eb731…`) is a
separate ECDSA trust assumption not rated here.

## Remediation

- Vizing (timelock `0x1ef0eff8…`): upgrade the validium proxy to an implementation whose verifier is post-quantum
  (STARK/FRI), or, since the chain has stopped, leave it with the bridge empty.
- Users: withdraw anything left in the bridge.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM -> LOW, step 5: escrow measured at about $165 (Vizing's L1 bridge 0x44db454c…). Project identified as Vizing Mainnet (chain id 28518) from the validium proxy 0x28328688… that calls this verifier (`networkName()`); `project` set to `vizing` (id kept). Admin path read: verifier is an immutable of the CDKValidium implementation, upgradeable through ProxyAdmin 0xe9175f66… and CDKValidiumTimelock 0x1ef0eff8… (24 h); fix layer onchain-config -> contract-upgrade.
- 2026-11-17 integration: id renamed from `unidentified-985e8913-snark-verifier` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: vizing-fflonk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x985e89135fb4968bca0db46422dc1ed31b985d52` — FflonkVerifier (verified source via sourcify)

### `contracts/verifiers/FflonkVerifier.sol`

```solidity
  158      
  159      uint16 constant lastMem = 1920;
  160       
  161  
  162      function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool) {
  163          assembly {
  164              // Computes the inverse of an array of values
  165              // See https://vitalik.ca/general/2018/07/21/starks_part_3.html in section where explain fields operations
  166              // To save the inverse to be computed on chain the prover sends the inverse as an evaluation in commits.eval_inv
  ...
 1160                  g1_mulAcc(add(pMem, pJ), pW1, numerator)
 1161              }
 1162  
 1163              // Validate all evaluations with a pairing checking that e([F]_1 - [E]_1 - [J]_1 + y[W2]_1, [1]_2) == e([W']_1, [x]_2)
 1164              function checkPairing(pMem) -> isOk {
 1165                  let mIn := mload(0x40)
 1166  
 1167                  // First pairing value
 1168                  // Compute -E
  ...
 1234              // Compute full batched polynomial commitment [F]_1, group-encoded batch evaluation [E]_1 and the full difference [J]_1
 1235              computeFEJ(pMem)
 1236  
 1237              // Validate all evaluations
 1238              let isValid := checkPairing(pMem)
 1239  
 1240              mstore(0, isValid)
 1241              return(0, 0x20)
 1242          }
  ...
```
