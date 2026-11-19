---
id: rarimo-plonk-verifier
title: "Rarimo ZK rollup: a PLONK proof forged with the recovered BN254 setup trapdoor finalizes a false L2 state on LineaRollup 0x2f3c2056 and releases its bridged ETH (~$3k)"
project: rarimo
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0xe067e0132137a517c86625e09dba914625e2f557"
  implementation: null
  name: PlonkVerifier (gnark), LineaRollup verifiers[3]
  upgradeable: "no"
  admin: "none; repointed or removed by VERIFIER_SETTER_ROLE / VERIFIER_UNSETTER_ROLE on rollup 0x2f3c2056, held by EOA 0xbbef10cea9eefd021069a1fc4a348c00e799b01b"
  value_usd: 3047
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-04-28
  txs_30d: 0
- address: "0x0c1f51ccb366177d2c09a6f446a55c2c8c86f074"
  implementation: null
  name: PlonkVerifier (gnark), LineaRollup verifiers[0]
  upgradeable: "no"
  admin: "none; removable by VERIFIER_UNSETTER_ROLE on rollup 0x2f3c2056 (EOA 0xbbef10ce)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: 0
- address: "0x77d5c96db33314244460cf89dd599525d7f3f847"
  implementation: null
  name: PlonkVerifier (gnark), LineaRollup verifiers[1]
  upgradeable: "no"
  admin: "none; removable by VERIFIER_UNSETTER_ROLE on rollup 0x2f3c2056 (EOA 0xbbef10ce)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-03-20
  txs_30d: 0
- address: "0xcdaaf2e3756409c93635adc3940233640e3004c6"
  implementation: null
  name: PlonkVerifier (gnark), LineaRollup verifiers[2]
  upgradeable: "no"
  admin: "none; removable by VERIFIER_UNSETTER_ROLE on rollup 0x2f3c2056 (EOA 0xbbef10ce)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-03-29
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Rarimo: EOA 0xbbef10cea9eefd021069a1fc4a348c00e799b01b (VERIFIER_SETTER_ROLE and VERIFIER_UNSETTER_ROLE on LineaRollup proxy 0x2f3c205613d9451f88e19e011ed23775afe00c41; also owner of its ProxyAdmin 0xb6b6e80bd32bca86ed5d60ff6889cff5e2d4f63f)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-plonk-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-plonk-verifier/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [rarimo-blob-kzg]
---

## Summary

The Rarimo ZK rollup (chain id 7368) settles on Ethereum through a LineaRollup v6.0 proxy at 0x2f3c2056, which
accepts a finalization if a gnark PLONK proof over BN254 verifies (PQ-7). A quantum attacker who recovers the setup
trapdoor can prove a false L2 state, including L2-to-L1 message roots of their choosing, and claim everything the rollup
can release: 1.68 ETH (about USD 3,047) held by the rollup itself plus dust in its token bridge. The verifier is
`0xe067e013…`, deployed by Rarimo's deployer, not Linea. One EOA can point the rollup at a new verifier, so the fix is
MEDIUM by step 4; under USD 50k is exposed, so the rating is LOW (step 5).

## Mechanism

- `LineaRollup.finalizeBlocks(_aggregatedProof, _proofType, _finalizationData)` (implementation `0x37139c71…`,
  `OPERATOR_ROLE` only) computes the public input from the shnarf, state roots and L2 message roots and calls
  `ZkEvmV2._verifyProof`, which looks up `verifiers[_proofType]` and calls `IPlonkVerifier.Verify(_proof, publicInput)`
  (`ZkEvmV2.sol` lines 40–60 in the excerpt).
- `PlonkVerifier.Verify` (gnark, `src/verifiers/PlonkVerifier.sol`) ends in `check_pairing_kzg`, a `staticcall` to the
  pairing precompile 0x08 with the verifying key's G2 SRS points (excerpt lines 885–907). The SRS comes from a
  pairing-based setup whose trapdoor a CRQC recovers, so a proof for any public input verifies.
- On success the rollup stores the L2 message Merkle roots; `L1MessageService.claimMessageWithProof` then pays out
  ETH held by the rollup proxy (and calls into the TokenBridge `0x54f014a2…` for bridged tokens) against a Merkle proof
  under one of those roots. A forged root releases any amount, up to the rate limit of 1,000 ETH per 86,400 s.
- Four verifiers are registered, all gnark `PlonkVerifier` contracts with BN254 pairings: proof type 3 (`0xe067e013…`)
  is the one used since 2025-04-01; types 0–2 remain registered and are equally accepted by `finalizeBlocks`.
- `finalizeBlocks` needs `OPERATOR_ROLE`. The operators are EOAs that have signed, so a CRQC also has their keys; and
  `setFallbackOperator` lets anyone grant `OPERATOR_ROLE` to the configured fallback (Multicall3 `0xca11bde0…`) once six
  months pass without a finalization, which (last finalization 2026-04-28) is now the case [INFERRED from the source
  and dates; not executed]. The operator gate does not stop the attack.

## Evidence

- CHECKED (Sourcify, exact match): all four verifiers are `src/verifiers/PlonkVerifier.sol:PlonkVerifier` with
  `staticcall` to precompile 8; LineaRollup implementation `0x37139c71…` source (`finalizeBlocks`, `_verifyProof`,
  `setFallbackOperator`, `claimMessageWithProof`).
- CHECKED (on-chain read, block 26,431,494): rollup proxy EIP-1967 implementation `0x37139c71…`, admin
  ProxyAdmin `0xb6b6e80b…`, whose `owner()` is EOA `0xbbef10ce…` (no code); `verifiers(0..3)` = `0x0c1f51cc…`,
  `0x77d5c96d…`, `0xcdaaf2e3…`, `0xe067e013…`, `verifiers(4..6)` = 0; `0xbbef10ce…` holds `DEFAULT_ADMIN_ROLE`,
  `VERIFIER_SETTER_ROLE`, `VERIFIER_UNSETTER_ROLE` and the pause roles; `limitInWei` = 1,000 ETH per day
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-plonk-verifier/review-reads.json)).
- CHECKED (Blockscout transaction list of the rollup, decoded `_proofType`): 321 `finalizeBlocks` calls, proof type 1
  (55, to 2025-03-20), type 2 (7, to 2025-03-29), type 3 (258, 2025-04-01 to 2026-04-28; last tx `0x090b42a2…` at
  block 24,976,740 calls `0xe067e013…`); type 0 never used.
- CHECKED (identification): Blockscout creator of `0xe067e013…` and of the rollup proxy is `0xbbef10ce…`; Rarimo's
  docs ([network info](https://docs.rarimo.com/zk-registry/network-info/)) list RollupProxy `0x2f3c2056…`,
  PlonkVerifier `0x0c1f51cc…`, Deployer and RollupSecurityCouncil `0xbbef10ce…`. Linea's LineaRollup `0xd19d4b5d…`
  has `verifiers(0)` = `0x0b3943f4…`, `verifiers(1)` = `0x1d930e3f…` and does not register `0xe067e013…`. The explorer
  label "Linea" refers to the code base, not the operator.
- CHECKED (Xatu, any function): `0xe067e013…` last called 2026-04-28, no calls 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-plonk-verifier/activity.json)); 231 pre-quantum calls in the
  year to March 2026 (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).

## Impact and exposure

| Contract | Role | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0xe067e013…` PlonkVerifier | verifiers[3], in use | no | $3,047 escrow | 2026-04-28 | 0 |
| `0x0c1f51cc…` PlonkVerifier | verifiers[0], never used | no | same escrow | — | 0 |
| `0x77d5c96d…` PlonkVerifier | verifiers[1] | no | same escrow | 2025-03-20 | 0 |
| `0xcdaaf2e3…` PlonkVerifier | verifiers[2] | no | same escrow | 2025-03-29 | 0 |

Escrow (block 26,431,494, ETH at USD 1,811.62): the rollup proxy `0x2f3c205613d9451f88e19e011ed23775afe00c41` holds
1.6818 ETH (USD 3,047), deposits from `sendMessage` (the last on 2026-07-20, after finalizations stopped); the
TokenBridge `0x54f014a2a5cb0480a7ceda2184d3543a025e7b3f` holds 0.00011 WETH (USD 0.20). The rollup has finalized L2
block 2,312 and its last finalization was 2026-04-28. Siblings: the four registered verifiers above; the blob opening is
[`rarimo-blob-kzg`](rarimo-blob-kzg.md).

## Remediation

- Replace the gnark PLONK/BN254 verifier with a hash-based (STARK/FRI or WHIR) verifier of the same circuit output and
  register it with `setVerifierAddress`; remove proof types 0–2 now with `unsetVerifierAddress`, since nothing uses
  them.
- Who acts: Rarimo, through EOA `0xbbef10cea9eefd021069a1fc4a348c00e799b01b` (verifier roles on the rollup and owner of
  ProxyAdmin `0xb6b6e80b…`). That admin is itself one ECDSA key that has signed on-chain; moving it to a multisig of
  post-quantum-capable accounts is part of the fix, since a CRQC holder of that key can upgrade the rollup directly.
- No protocol change is needed. Users can withdraw bridged ETH to L1 while the rollup still finalizes.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> LOW, step 5: one EOA can repoint the verifier (step 4 MEDIUM), and the measured escrow is USD 3,047 (rollup ETH + token bridge). Project identified as Rarimo ZK rollup (docs address book, Blockscout creator); `0xe067e013…` is Rarimo's verifiers[3], not Linea's, so it stays here rather than in `linea-plonk-verifier-bn254`. Added the other three registered verifiers (proof types 0–2).
- 2026-11-17 integration: id renamed from `unidentified-2f3c2056-snark-verifier` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: rarimo-plonk-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xe067e0132137a517c86625e09dba914625e2f557` — PlonkVerifier (verified source via sourcify)

### `src/verifiers/PlonkVerifier.sol`

```solidity
  281          mstore(add(ptError, 0x44), "openings bigger than r")
  282          revert(ptError, 0x64)
  283        }
  284  
  285        function error_pairing() {
  286          let ptError := mload(0x40)
  287          mstore(ptError, ERROR_STRING_ID) // selector for function Error(string)
  288          mstore(add(ptError, 0x4), 0x20)
  289          mstore(add(ptError, 0x24), 0xd)
  290          mstore(add(ptError, 0x44), "error pairing")
  291          revert(ptError, 0x64)
  292        }
  293  
  294        function error_verify() {
  ...
  887          mstore(add(mPtr, 0x100), G2_SRS_1_X_0) 
  888          mstore(add(mPtr, 0x120), G2_SRS_1_X_1) 
  889          mstore(add(mPtr, 0x140), G2_SRS_1_Y_0) 
  890          mstore(add(mPtr, 0x160), G2_SRS_1_Y_1) 
  891          check_pairing_kzg(mPtr)
  892        }
  893  
  894        /// @notice check_pairing_kzg checks the result of the final pairing product of the batched
  895        /// kzg verification. The purpose of this function is to avoid exhausting the stack
  896        /// in the function batch_verify_multi_points.
  897        /// @param mPtr pointer storing the tuple of pairs
  898        function check_pairing_kzg(mPtr) {
  899          let state := mload(0x40)
  900  
  901          let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  902          if iszero(l_success) {
  903            error_pairing()
  904          }
  905          let res_pairing := mload(0x00)
  906          mstore(add(state, STATE_SUCCESS), res_pairing)
  907        }
  908  
  909        /// @notice Fold the opening proofs at ζ:
  910        /// * at state+state_folded_digest we store: [Linearised_polynomial]+γ[L] + γ²[R] + γ³[O] + γ⁴[S₁] +γ⁵[S₂] + ∑ᵢγ⁵⁺ⁱ[Pi_{i}]
  ...
```
