---
id: loopring-groth16-verifier
title: "Loopring: the Groth16 BN254 BlockVerifier no longer secures anything; the Loopring 3.x exchange was replaced by an owner-only executor on 2026-06-29 and its deposit contract holds $2k"
project: loopring
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: none
alternative: configurable-verifier
role: core
contracts:
- address: "0x6150343e0f43a17519c0327c41edd9ebe88d01ef"
  implementation: null
  name: BlockVerifier (Loopring 3.x)
  upgradeable: config-only
  admin: "owner (Claimable) Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97 (2 of 3) registers/disables circuits, read at block 26431597"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-06-27
  txs_30d: 0
families: []
fix:
  layer: none
  who_acts: "No action needed for this path: Loopring's Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97 (2 of 3), owner of the exchange proxy 0x0baba1ad5be3a5c0a66e7ac838a129bf948f1ea4, already replaced ExchangeV3 with ProxyAdminExecutor"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/loopring-groth16-verifier
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, cast reads at block 26431597, Blockscout
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Loopring 3.x checked each L2 block with a Groth16 proof on BN254 in `BlockVerifier` (PQ-7); with the setup trapdoor a
false block would have verified and released funds from the exchange's deposit contract. Since block 25,421,921
(2026-06-29) the exchange proxy runs `ProxyAdminExecutor`, which has no block submission and never calls the verifier,
and the deposit contract holds $2,152. A forged proof now releases nothing. Rated LOW, step 4: nothing can be taken
through the check (also step 5: under $50k).

## Mechanism

- `BlockVerifier.verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)` (`BlockVerifier.sol` lines
  1220–1252) loads the owner-registered Groth16 verification key for the circuit and runs `Verifier.Verify` (ethsnarks)
  or `BatchVerifier.BatchVerify` (matter-labs), both ending in the BN254 pairing precompile (lines 656, 516).
- Its consumer was `ExchangeV3` behind proxy `0x0baba1ad…`, whose block submission (through the operator contract
  `LoopringIOExchangeOwner`) required this check before accepting new Merkle roots that withdrawals from
  DepositContract `0x674bdf20…` were proven against.
- The proxy now points at `ProxyAdminExecutor` (`transact`, `sendNfts`, owner-only), so the verifier is unreachable from
  the exchange. Pattern PQ-7.

## Evidence

- CHECKED (Sourcify full source of `0x6150343e…`, read 2026-11-17): `verifyProofs`, `registerCircuit`,
  `disableCircuit` ([`notes.md`](#review-notes-review12-2026-11-17)).
- CHECKED (cast at block 26,431,597): BlockVerifier `owner()` and exchange `proxyOwner()` are Safe `0xdd2a08a1…`,
  threshold 2 of 3 owners.
- CHECKED (cast `eth_getStorageAt`, binary search): exchange implementation `0x26d8ba77…` (`ExchangeV3`) up to block
  25,421,920, `0xb2de2bff…` (`ProxyAdminExecutor`, Blockscout-verified) from block 25,421,921.
- CHECKED (Blockscout, 2026-11-17): DepositContract `0x674bdf20…` (`exchange()` = `0x0baba1ad…`) holds 0 ETH and $2,152
  in ERC-20s; the verifier holds nothing (block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/loopring-groth16-verifier/onchain.json)).
- CHECKED (Xatu): last call 2026-06-27, none in 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/loopring-groth16-verifier/activity.json)); precompile trace, year to March 2026:
  8,450 transactions, $14.7M moved in them (`curated_contracts.csv`, `txs_y1`, `usd_tx_y1`).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x6150343e…` BlockVerifier | config-only | $0 (escrow released by a forged proof) | 2026-06-27 | 0 |

- Escrow: none reachable. The DepositContract's remaining $2,152 can move only through the Safe-controlled executor,
  which is a question of the Safe owners' keys (PQ-12), not of this verifier.
- Other Loopring exchange deployments (Blockscout lists several `ExchangeV3` and `LoopringIOExchangeOwner` contracts)
  were not checked against this verifier.

## Remediation

- None needed for this path while the exchange runs `ProxyAdminExecutor`. If Loopring ever restores a proof-verifying
  exchange, it should use a hash-based (STARK/FRI) verifier rather than registering new Groth16 circuits here.
- Who acts: Loopring's Safe `0xdd2a08a1…` (2 of 3), which owns both the verifier and the exchange proxy. No protocol
  change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> LOW, step 4: nothing can be taken through the check; the exchange proxy 0x0baba1ad was switched from ExchangeV3 to an owner-only ProxyAdminExecutor at block 25,421,921 and no longer calls the verifier (also step 5: DepositContract holds $2,152). Impact funds-loss -> none; fix.layer onchain-config -> none.

# Source excerpts: loopring-groth16-verifier

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x6150343e0f43a17519c0327c41edd9ebe88d01ef` — BlockVerifier (verified source via sourcify)

### `BlockVerifier.sol`

```solidity
  165      /// @param blockVersion The block version (i.e. which circuit version needs to be used)
  166      /// @param publicInputs The hash of all the public data of the blocks
  167      /// @param proofs The ZK proofs proving that the blocks are correct
  168      /// @return True if the block is valid, false otherwise
  169      function verifyProofs(
  170          uint8  blockType,
  171          uint16 blockSize,
  172          uint8  blockVersion,
  173          uint[] calldata publicInputs,
  ...
  577          vk_x = ic[0]
  578          for i, s in enumerate(inputs):
  579              vk_x = add(vk_x, multiply(ic[i + 1], s))
  580  
  581          check_1 = pairing(proof_B, proof_A)
  582          check_2 = pairing(vk_beta, neg(vk_alpha))
  583          check_3 = pairing(vk_gamma, neg(vk_x))
  584          check_4 = pairing(vk_delta, neg(proof_C))
  585  
  586          ok = check_1 * check_2 * check_3 * check_4
  587          assert ok == FQ12.one()
  588      */
  ...
 1216              blockVersion
 1217          );
 1218      }
 1219  
 1220      function verifyProofs(
 1221          uint8  blockType,
 1222          uint16 blockSize,
 1223          uint8  blockVersion,
 1224          uint[] calldata publicInputs,
  ...
```

# Review notes (Review12, 2026-11-17)

- Source: Sourcify `BlockVerifier.sol` of 0x6150343e0f43a17519c0327c41edd9ebe88d01ef.
  - `verifyProofs(blockType, blockSize, blockVersion, publicInputs, proofs)` (lines 1220–1252): looks up the registered
    circuit's Groth16 verification key, then `Verifier.Verify` (ethsnarks, pairing `staticcall(…, 8, …)` at line 656)
    or `BatchVerifier.BatchVerify` (matter-labs, pairing at line 516). BN254.
  - `registerCircuit` / `disableCircuit` (lines 137–160) are owner-only (`Claimable`).
- cast (https://eth.drpc.org), block 26,431,597: BlockVerifier `owner()` = Safe 0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97,
  `getThreshold()` = 2 (owners 0x0f026a3e…, 0x576abc47…, 0x1f28f101…, read at block 26,431,214 in onchain.json).
- Loopring exchange proxy 0x0baba1ad5be3a5c0a66e7ac838a129bf948f1ea4 (ZeppelinOS `OwnedUpgradabilityProxy`):
  `proxyOwner()` = the same Safe; implementation slot keccak("org.zeppelinos.proxy.implementation") =
  0x26d8ba776a067c5928841985bce342f75bae7e82 (Blockscout name `ExchangeV3`) up to block 25,421,920, and
  0xb2de2bff671b03612a0fa3340e0e0ee7e1c0a388 (`ProxyAdminExecutor`, verified; only `transact` and `sendNfts`, both
  restricted to the proxy owner) from block 25,421,921 (2026-06-29 07:46 UTC) to now (binary search over
  `eth_getStorageAt`).
- DepositContract 0x674bdf20a0f284d710bc40872100128e2d66bd3f (`DefaultDepositContract`, `exchange()` = 0x0baba1ad…):
  0 ETH and $2,152 in ERC-20s (BUSD $992, cETH $670, OVR $209, cDAI $62; Blockscout, 2026-11-17). Exchange proxy holds
  about $1.
- Last call of the verifier in the activity scan: block 25,405,609 (2026-06-27).
