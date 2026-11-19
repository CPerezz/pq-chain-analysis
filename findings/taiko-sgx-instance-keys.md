---
id: taiko-sgx-instance-keys
title: "Taiko: SGX instance ECDSA keys sign every L1 proof; with a quantum computer a forged instance signature plus a forged BN254 ZK proof finalizes a false L2 state that releases the L1 bridge and vaults (USD 9.9M)"
project: taiko
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee"
  implementation: null
  name: SecureSgxVerifier (SGX_GETH, live in ZkRequiredVerifier)
  upgradeable: config-only
  admin: not a proxy; Ownable2Step owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController, owned by Taiko DAO 0x9cdf589c941ee81d75f34d3755671d614f7cf261) adds/deletes instances; registrar Safe 0x9cbee534b5d8a6280e01a14844ee8af350399c7f (4 of 6) calls registerInstance; replacing it needs a Shasta inbox upgrade
  value_usd: 9946783
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: 1357
- address: "0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8"
  implementation: null
  name: SecureSgxVerifier (SGX_RETH, live in ZkRequiredVerifier, unused in recent proofs)
  upgradeable: config-only
  admin: not a proxy; Ownable2Step owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController); registrar Safe 0x9cbee534b5d8a6280e01a14844ee8af350399c7f
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-19
  txs_30d: 2
- address: "0x7e6409e9b6c5e2064064a6cc994f9a2e95680782"
  implementation: "0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5"
  name: ERC1967Proxy → SgxVerifier (Pacaya sgxGethVerifier, retired)
  upgradeable: "yes"
  admin: UUPS owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-04-02
  txs_30d: 0
- address: "0x9e322fc59b8f4a29e6b25c3a166ac1892aa30136"
  implementation: "0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5"
  name: ERC1967Proxy → SgxVerifier (Pacaya sgxRethVerifier, retired)
  upgradeable: "yes"
  admin: UUPS owner 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a (TaikoDAOController)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-22
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: Taiko DAO 0x9cdf589c941ee81d75f34d3755671d614f7cf261 (Aragon OSx; standard proposals from Security Council multisig 0xd7da1c25e915438720692bc55eb3a7170ca90321, 3 of 5 signers, through optimistic token voting 0x989e348275b659d36f8751ea1c10d146211650be; emergency multisig 0x2affadeb2ef5e1f2a7f58964ee191f1e88317ecd, 4 of 5) acting through TaikoDAOController 0x75ba76403b13b26ad1bec70d6ee937314eeacd0a, which owns the Shasta inbox proxy 0x6f21c543a4af5189ebdb0723827577e1ef57ef1f and the SGX verifiers
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/taiko-sgx-instance-keys
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier and SecureSgxVerifier; on-chain reads at block 26,431,535)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/taiko-sgx-instance-keys/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 6610c7aa"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [taiko-zk-verifiers]
---

## Summary

Every Taiko L1 proof today carries a signature from an SGX enclave key, checked with `ecrecover` in `SecureSgxVerifier.verifyProof`. The enclave addresses are registered on chain and sign every proof, so their public keys are known. A quantum attacker can recover such a key and sign any state transition. The SGX signature alone is not enough: the live `ZkRequiredVerifier` also needs a RISC Zero or SP1 proof, and both of those are BN254 SNARKs that the same attacker can forge (see `taiko-zk-verifiers`). So the two-proof design gives no post-quantum protection. A false L2 state root lets the attacker withdraw from the L1 Bridge and ERC20Vault, which held USD 9.9M on 2026-11-17. Rated MEDIUM at step 4: the Taiko DAO can fix it by upgrading the inbox and verifiers, with no protocol change.

## Mechanism

Live path (Shasta, since the fork at 2026-04-02 13:15 UTC):

1. `MainnetInbox.prove(_data, _proof)` on the inbox proxy `0x6f21c543…` (implementation `0xa18431d4…`, `Inbox.sol` lines 321–399) first finalises the commitment. It calls `_signalService.saveCheckpoint(blockNumber, stateRoot, blockHash)` on SignalService `0x9e0a2496…`, then calls `_proofVerifier.verifyProof(...)`, which reverts the transaction if the proof is wrong.
2. `_proofVerifier` is the immutable `ZkRequiredVerifier` `0x7284aac0…`. `ComposeVerifier.verifyProof` decodes `SubProof[]`, calls each sub-verifier by ID and then calls `areVerifiersSufficient`. That function accepts exactly two sub-proofs: (SGX_GETH or SGX_RETH) plus (RISC0_RETH or SP1_RETH), or RISC0_RETH plus SP1_RETH.
3. SGX_GETH = `SecureSgxVerifier` `0x41e79eb4…`. SGX_RETH = `SecureSgxVerifier` `0x9d3c595b…`. `SgxVerifier.verifyProof` (lines 167–188) takes an 89-byte proof: `id ‖ instance ‖ signature`. It checks `_isInstanceValid(id, instance)` (registered and under 365 days old), hashes the commitment with `LibPublicInput.hashPublicInputs`, and requires `instance == ECDSA.recover(signatureHash, signature)`. This is PQ-4: a fixed secp256k1 key authorises a value-moving state transition.
4. Instances get in through `registerInstance(attestation)`, which only the registrar Safe `0x9cbee534…` can call. It calls `AutomataDcapV3Attestation.verifyParsedQuote` (proxies `0x0ffa4a62…` and `0x8d7c9549…`). Those verify Intel's PCK certificate chain, the quoting-enclave report and the quote with `SigVerifyLib.verifyES256Signature` (`0x47bb416e…`), which is P-256 ECDSA over sha256. That makes attestation a second pre-quantum dependency: with a CRQC, the Intel P-256 keys can be recovered and a quote forged for an attacker-chosen key. Registration is gated by a 4-of-6 Safe, but the Safe owners are ECDSA keys too. The owner can also call `addInstances` with no attestation at all.
5. With the checkpoint saved, `Bridge.processMessage` (`0xd60247c6…`, implementation `0xe6bf63dc…`) checks a storage proof through `signalService.proveSignalReceived` against that state root. It then releases ETH, or calls the vaults, which release tokens.

Retired path (Pacaya): the old inbox `0x06a9ab27…` (`inbox.based.taiko.eth`) calls `MainnetVerifier` `0xb16931e7…`, whose sub-verifiers include SgxVerifier proxies `0x7e6409e9…` (sgxGeth) and `0x9e322fc5…` (sgxReth). Its `SgxVerifier.verifyProof` (excerpt lines 148–188) has the same `ecrecover` check on a 109-byte proof. The path is retired:

- every Pacaya batch is verified (`getStats2`: numBatches 1,363,318, lastVerifiedBatchId 1,363,317);
- after `shastaForkTimestamp` (1775135700), `_verifyBatches` no longer syncs state roots to SignalService (TaikoInbox line 699);
- SignalService only accepts `saveCheckpoint` from its immutable authorised syncer, which is the Shasta inbox.

A forged proof on this path releases nothing.

Source excerpts: [`source-excerpts.md`](#source-excerpts-taiko-sgx-instance-keys). Pattern PQ-4 in `patterns.md`.

## Evidence

- CHECKED (precompile trace, all mainnet transactions to March 2026): `ecrecover` used by the Pacaya SGX verifiers.
- CHECKED (verified source, Sourcify): Shasta `MainnetInbox` `0xa18431d4…` (`Inbox.prove`), `ZkRequiredVerifier` `0x7284aac0…`, `SecureSgxVerifier`/`SgxVerifier` `0x41e79eb4…`, Pacaya `MainnetInbox` `0x38dd73fe…`, `MainnetVerifier` `0x8c520bb7…`, SgxVerifier `0xdb7aee4f…` and `0x8addcf5d…`, `TaikoDAOController` `0x4347df63…`, `AutomataDcapV3Attestation` `0x5e46443b…`. Also read: `SigVerifyLib` `0x47bb416e…` (Blockscout), SignalService `0x1a068329…` and Bridge `0xe6bf63dc…` (relevant functions only).
- CHECKED (on-chain reads at block 26,431,535, 2026-11-17; [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/taiko-sgx-instance-keys/escrow.json)):
  - Shasta inbox: proxy `0x6f21c543…` (found from SignalService `CheckpointSaved` logs), `owner()` = TaikoDAOController, `getConfig().proofVerifier` = `0x7284aac0…`.
  - ZkRequiredVerifier: sub-verifier immutables; not a proxy, no owner.
  - SecureSgxVerifier ×2: `owner()`, `registrar()`, `automataDcapAttestation()`, `nextInstanceId` = 4, one valid instance each.
  - Pacaya inbox: `verifier()`, `shastaForkTimestamp()`, `getStats2()`; `MainnetVerifier` sub-verifiers.
  - Governance: EIP-1967 slots and `owner()` of every proxy above. `0x75ba7640…` = TaikoDAOController (`controller.taiko.eth`), owner `0x9cdf589c…` (Aragon DAO, `dao.taiko.eth`). The DAO executes only through OptimisticTokenVotingPlugin `0x989e3482…` (all `Executed` events). Multisig `0xd7da1c25…` (minApprovals 3) and EmergencyMultisig `0x2affadeb…` (minApprovals 4) share a signer list of 5. Registrar Safe `0x9cbee534…` has threshold 4 of 6.
- CHECKED (proof composition, [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/taiko-sgx-instance-keys/escrow.json) `proofs_30d`): all 1,369 `prove` transactions in blocks 26,208,000–26,431,535 were decoded. Every one carried an SGX_GETH sub-proof from `0x41e79eb4…`: 704 with SP1 and 665 with RISC Zero. SGX_RETH was never used. All came from prover EOA `0xa5cb34b7…`, which is whitelisted in ProverWhitelist `0xea798547…` (2 provers).
- CHECKED: SGX instances are rotated. On both live verifiers the DAO deleted the instance at block 26,223,334 and the registrar Safe registered a new one at block 26,223,342 (2026-10-19). Each new key then signs every proof, so its public key is exposed straight away.
- CHECKED (Xatu activity, any function): Pacaya proxies last called 2026-04-02 (`0x7e6409e9…`) and 2026-06-22 (`0x9e322fc5…`, `registerInstance`). No calls in 2026-10-16 to 2026-11-16.
- INFERRED: the ERC20Vault releases bridged tokens after `Bridge.processMessage` (standard Taiko design; vault source not read here).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x41e79eb4…` SecureSgxVerifier (SGX_GETH, live) | config-only | 0 (escrow USD 9.9M) | 2026-11-17 | 1,357 |
| `0x9d3c595b…` SecureSgxVerifier (SGX_RETH, live) | config-only | 0 | 2026-10-19 | 2 |
| `0x7e6409e9…` SgxVerifier proxy (Pacaya, retired) | yes | 0 | 2026-04-02 | 0 |
| `0x9e322fc5…` SgxVerifier proxy (Pacaya, retired) | yes | 0 | 2026-06-22 | 0 |

Escrow: what a false finalised state root can release, read at block 26,431,535. Addresses come from resolver `0x8efa0156…` `resolve(1, name)`, the Bridge's resolver.

- Bridge `0xd60247c6848b7ca29eddf63aa924e53db6ddd8ec`: 878.04 ETH = USD 1,590,675 at USD 1,811.62.
- ERC20Vault `0x996282ca11e5deb6b5d122cc3b9a1fcaad4415ab`: USD 8,356,107 in priced tokens (Blockscout `exchange_rate`, 2026-11-17). Includes:
  - 137,975,153 TAIKO at USD 0.058361 = USD 8,052,368;
  - 221,690 USDC = USD 221,606;
  - 20.70 WETH = USD 37,573;
  - 33,928 USDT = USD 33,904;
  - 48 smaller tokens.
- ERC721Vault `0x0b470dd3a0e1c41228856fb319649e7c08f419aa` and ERC1155Vault `0xaf145913ea4a56be22e120ed9c24589659881702`: NFTs only (50 and 21 collections), not priced.
- SignalService `0x9e0a2496…`: 0.

Total USD 9,946,783, entered on `0x41e79eb4…`. `taiko-zk-verifiers` puts the same escrow on `0x7284aac0…`; the two are not additive. QuotaManager `0xbacb003f…` (owner: the 4-of-6 Safe) caps withdrawals per 24 hours: 250 ETH, 10M TAIKO, 250k USDC. The Bridge and SignalService pauser is the same Safe. These slow a drain and allow a pause once someone notices, but do not stop it.

The SGX signature is never enough on its own: `ZkRequiredVerifier` always needs a ZK sub-proof, and RISC0+SP1 needs no SGX at all. Funds are takeable today because the ZK side is also pre-quantum. If Taiko switched to post-quantum ZK verifiers, this finding would expose nothing by itself.

The Pacaya inbox still holds 812,589 TAIKO in liveness bonds (about USD 47k). No unverified batch is left to prove, so this is not counted.

## Remediation

- The scheme is fixed, so rotating the key does not help. Every instance key signs proofs on chain, which exposes its public key.
- Post-quantum fix: have the enclave sign with a post-quantum scheme (ML-DSA or a hash-based signature, bound in the attestation report), and replace the P-256 DCAP chain check, which needs Intel to publish post-quantum attestation keys. Alternatively, accept only proof combinations whose ZK verifiers are post-quantum (STARK/FRI), with SGX as an extra check.
- Who acts: the Taiko DAO through TaikoDAOController `0x75ba7640…`. Every verifier address is an immutable of `ZkRequiredVerifier` and of the inbox implementation, so the fix means deploying new verifiers and a new compose verifier, then upgrading the Shasta inbox proxy `0x6f21c543…` (UUPS, owner TaikoDAOController). No Ethereum protocol change is needed.
- The DAO's own approvals rest on ECDSA keys: Security Council signers and token voters. That is outside this finding (PQ-12), but it decides how fast the upgrade can be trusted.
- Users cannot protect bridged funds themselves, other than by withdrawing them to L1.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> MEDIUM, step 4: the listed SgxVerifier proxies are on the retired Pacaya path. Added the live SecureSgxVerifiers `0x41e79eb4…`/`0x9d3c595b…` used by Shasta `ZkRequiredVerifier`. Alternative changed from key-rotation-only to configurable-verifier (the DAO can upgrade the inbox to a new verifier set). Admin confirmed as TaikoDAOController owned by the Taiko DAO. Escrow measured: USD 9,946,783 (Bridge plus ERC20Vault). SGX alone is insufficient but the required ZK leg is BN254, so both fall to a CRQC. Noted the DCAP (P-256) attestation dependency.
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

# Source excerpts: taiko-sgx-instance-keys

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7e6409e9b6c5e2064064a6cc994f9a2e95680782` — ERC1967Proxy (verified source via blockscout)

## Implementation `0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5` — SgxVerifier (verified source via sourcify)

### `contracts/layer1/verifiers/IVerifier.sol`

```solidity
   15  
   16      /// @notice Verifies multiple proofs. This function must throw if the proof cannot be verified.
   17      /// @param _ctxs The array of contexts for the proof verifications.
   18      /// @param _proof The batch proof to verify.
   19      function verifyProof(Context[] calldata _ctxs, bytes calldata _proof) external;
   20  }
  ...
```

### `contracts/layer1/verifiers/SgxVerifier.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.24;
    3  
    4  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    5  import "src/shared/common/EssentialContract.sol";
    6  import "src/shared/libs/LibStrings.sol";
    7  import "../automata-attestation/interfaces/IAttestation.sol";
    8  import "../automata-attestation/lib/QuoteV3Auth/V3Struct.sol";
  ...
  144          return _addInstances(addresses, false)[0];
  145      }
  146  
  147      /// @inheritdoc IVerifier
  148      function verifyProof(
  149          Context[] calldata _ctxs,
  150          bytes calldata _proof
  151      )
  152          external
  ...
  176  
  177          bytes32 signatureHash = keccak256(abi.encodePacked(publicInputs));
  178          // Verify the blocks
  179          bytes memory signature = _proof[44:];
  180          require(oldInstance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  181  
  182          uint32 id = uint32(bytes4(_proof[:4]));
  183          require(_isInstanceValid(id, oldInstance), SGX_INVALID_INSTANCE());
  184  
  ...
```

Library files with the primitive itself (not excerpted): `node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol`


## Contract `0x9e322fc59b8f4a29e6b25c3a166ac1892aa30136` — ERC1967Proxy (verified source via blockscout)

## Implementation `0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5` — SgxVerifier (verified source via sourcify)

### `contracts/layer1/verifiers/IVerifier.sol`

```solidity
   15  
   16      /// @notice Verifies multiple proofs. This function must throw if the proof cannot be verified.
   17      /// @param _ctxs The array of contexts for the proof verifications.
   18      /// @param _proof The batch proof to verify.
   19      function verifyProof(Context[] calldata _ctxs, bytes calldata _proof) external;
   20  }
  ...
```

### `contracts/layer1/verifiers/SgxVerifier.sol`

```solidity
    1  // SPDX-License-Identifier: MIT
    2  pragma solidity ^0.8.24;
    3  
    4  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    5  import "src/shared/common/EssentialContract.sol";
    6  import "src/shared/libs/LibStrings.sol";
    7  import "../automata-attestation/interfaces/IAttestation.sol";
    8  import "../automata-attestation/lib/QuoteV3Auth/V3Struct.sol";
  ...
  144          return _addInstances(addresses, false)[0];
  145      }
  146  
  147      /// @inheritdoc IVerifier
  148      function verifyProof(
  149          Context[] calldata _ctxs,
  150          bytes calldata _proof
  151      )
  152          external
  ...
  176  
  177          bytes32 signatureHash = keccak256(abi.encodePacked(publicInputs));
  178          // Verify the blocks
  179          bytes memory signature = _proof[44:];
  180          require(oldInstance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  181  
  182          uint32 id = uint32(bytes4(_proof[:4]));
  183          require(_isInstanceValid(id, oldInstance), SGX_INVALID_INSTANCE());
  184  
  ...
```

Library files with the primitive itself (not excerpted): `node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol`
