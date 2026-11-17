---
id: ethstorage-blob-kzg
title: "EthStorage storage contract: storage proofs open users' blobs with KZG point evaluation; with the KZG setup trapdoor a whitelisted miner can collect mining rewards (USD 321 pool) without holding the data, and the blob commitments cannot be swapped for another scheme"
project: ethstorage
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xf0193d6e8fc186e77b6e63af4151db07524f6a7a"
  implementation: "0x99f5cc6ad111584c88891b4c6fff5784a46adf33"
  name: TransparentUpgradeableProxy -> EthStorageContractM2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372, owner Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c (1 of 2); the Safe also holds DEFAULT_ADMIN_ROLE (miner whitelist)"
  value_usd: 321
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 94
families: []
fix:
  layer: contract-upgrade
  who_acts: "EthStorage (Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c via ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372) upgrades the contract to add a non-KZG storage path, which needs users to upload again; post-quantum data availability in the Ethereum protocol would cover blob-stored data without that migration"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/ethstorage-blob-kzg/notes.md
  - evidence/ethstorage-blob-kzg/source-excerpts.md
  - evidence/ethstorage-blob-kzg/onchain.json
  - evidence/ethstorage-blob-kzg/activity.json
sources:
- by: ai-assisted
  who: Review15 (finding review)
  ref: findings/ethstorage-blob-kzg.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: [ethstorage-mining-groth16]
---

## Summary

EthStorage stores users' data as EIP-4844 blobs and pays whitelisted miners for proving they keep it. Each storage
proof opens the stored blob at a random point with the KZG point-evaluation precompile (PQ-8). With the KZG ceremony's
trapdoor, a miner can open any value, so it can be paid without holding users' data; the reward pool is the
contract's balance, USD 321 on 2026-11-17. The only commitment to stored data is the blob's KZG versioned hash, and the
contract has no non-blob storage path, so no admin setting removes the dependency. Rated LOW (MEDIUM at step 4: an
upgrade by the Safe can add a non-KZG storage path, with users uploading their data again; lowered at step 5: under
USD 50k exposed).

## Mechanism

- `putBlob` / `putBlobs` (`EthStorageContract.sol` 175–215) store `blobhash(i)` as the entry's `hash`; no other put
  function exists.
- `StorageContract.mine` (whitelisted `miner`, `enforceMinerRole() = true`) -> `_mine` ->
  `EthStorageContractM2.verifySamples` -> `_checkSample` (`EthStorageContractM2.sol` 76–95) ->
  `checkInclusive(hash, sampleIdx, mask ^ encodedSample, peInput)` (`EthStorageContract.sol` 132–156): for a stored
  entry it calls `_pointEvaluation` (108–124, `STATICCALL` to `0x0a`) and requires the opened point to be
  `RU_BLS^reverse(sampleIdx)`, the versioned hash to match, and the opened value to equal the decoded sample. If the
  difficulty is met, `_rewardMiner` pays the miner from the contract balance.
- With the trapdoor, the miner picks the decoded value and forges the opening; the Groth16 decoding proof
  (`ethstorage-mining-groth16`) can then be made honestly from those values, so the KZG forgery alone avoids storing
  the data.

Pattern PQ-8. Excerpt: [`source-excerpts.md`](../evidence/ethstorage-blob-kzg/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x99f5…df33`): the path above; `blobhash` is the only source
  of entry hashes ([`notes.md`](../evidence/ethstorage-blob-kzg/notes.md)).
- CHECKED (block 26,431,725): implementation slot `0x99f5cc6a…`; balance 0.17725 ETH; `kvEntryCount() = 3338`,
  `shardEntryBits() = 22`, `randomChecks() = 2`, `enforceMinerRole() = true`. Admin chain (ProxyAdmin, 1-of-2 Safe)
  read at block 26,431,543 (`ethstorage-mining-groth16` evidence).
- CHECKED (precompile trace, all time): no `pointEval` call from this contract; 260 mining proofs all hit empty
  entries (`hash == 0`), where `checkInclusive` needs no opening. The KZG path becomes active as the shard fills
  (3,338 of 4,194,304 entries used).
- CHECKED (Xatu, any function): 94 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](../evidence/ethstorage-blob-kzg/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf0193d6e…` EthStorageContractM2 | yes (1-of-2 Safe) | USD 321 (held: reward pool) | 2026-11-15 | 94 |

Who can exploit it: only miners on the whitelist kept by the Safe. What is lost: the reward pool (funded by users'
storage payments) and the guarantee that users' data is kept; the data loss is not valued here. Anyone can upload
blobs, but uploading releases nothing.

## Remediation

- No fallback exists that the admin can switch to: entries are committed only by KZG versioned hashes, so existing
  data cannot be proven any other way. An upgrade by the Safe could add a non-KZG storage path (data in calldata with
  a hash-based commitment, proven with a STARK), but users would have to upload again; post-quantum blob data
  availability needs an Ethereum protocol change.
- Until then the miner whitelist limits who can cheat. The Safe owners are ECDSA EOAs and should move to post-quantum
  signers.

## History

- 2026-11-17: created in review (Review15) from the KZG opening noted in `ethstorage-mining-groth16`; verified source and on-chain state read at block 26,431,725. Rated MEDIUM (step 4 HIGH: KZG dependency with no switchable fallback; step 5: under USD 50k exposed).
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4 (HIGH -> MEDIUM): an upgrade by the Safe can add a non-KZG storage path, with users re-uploading their data (an upgrade plus a migration), then step 5 (USD 321 exposed, under USD 50k) lowers it to LOW; `fix.layer` protocol -> contract-upgrade, `protocol_change` required -> helps.
