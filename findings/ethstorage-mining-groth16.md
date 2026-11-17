---
id: ethstorage-mining-groth16
title: "EthStorage storage contract: with the Groth16 setup trapdoor, a whitelisted miner can pass the sample-decoding proof in mine() without storing its encoded replica and collect rewards from the contract's USD 321 balance"
project: ethstorage
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xf0193d6e8fc186e77b6e63af4151db07524f6a7a"
  implementation: "0x99f5cc6ad111584c88891b4c6fff5784a46adf33"
  name: TransparentUpgradeableProxy -> EthStorageContractM2
  upgradeable: "yes"
  admin: "ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372, owner Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c (1 of 2); the Safe also holds DEFAULT_ADMIN_ROLE (miner whitelist) and is the treasury"
  value_usd: 321
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 94
families: []
fix:
  layer: contract-upgrade
  who_acts: "EthStorage: Safe 0xa10d87502a0d8fce45610c6028f0756383649f3c (1 of 2: 0x6fd772e4f7129c259a3c10650a24acc61802971f, 0x905d49785b3d28714a9bc7532f74c5a2228e0602) upgrades the proxy through ProxyAdmin 0x654dd56444856e928917549263aac6f9d6a96372"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethstorage-mining-groth16
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review15 (finding review)
  ref: findings/ethstorage-mining-groth16.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [ethstorage-blob-kzg]
---

## Summary

EthStorage's storage contract pays miners for proving they store an encoded replica of users' blobs. The proof that
the samples were encoded with the miner's own key is a Groth16 proof on BN254 (PQ-7); with the setup trapdoor a
miner can make it verify for any mask, so it can collect rewards without keeping its unique replica, and the storage
guarantee for users' data weakens. Only whitelisted miners can be paid, and the reward pool is the contract's balance,
0.177 ETH (USD 321, 2026-11-17). The proxy is upgradeable by a 1-of-2 Safe. Rated LOW (step 5: an upgrade fix, MEDIUM
at step 4, with under USD 50k exposed).

## Mechanism

`StorageContract.mine(blockNum, shardId, miner, nonce, encodedSamples, masks, randaoProof, inclusiveProofs,
decodeProof)` requires `hasRole(MINER_ROLE, miner)` (enforced: `enforceMinerRole() = true`) and calls
`_mine` -> `EthStorageContractM2.verifySamples`. For each of the random samples, `_checkSample` calls
`checkInclusive(dataHash, sampleIdx, mask ^ encodedSample, peInput)`, a KZG point-evaluation (precompile `0x0a`) opening
of the stored blob. Then `decodeSamples` builds six public signals (encoding keys
`keccak(dataHash, miner, kvIdx) mod r`, evaluation points `RU_BN254^sampleIdx` via `modexp`, and the two masks) and
calls `Decoder2.verifyProof`, a snarkjs Groth16 verifier whose `checkPairing` calls the BN254 pairing precompile
(`Decoder2.sol` 112–176). If the difficulty is met, `_rewardMiner` pays `minerReward` from the contract balance to
`miner` with `transfer`.

With the Groth16 trapdoor, the masks need not derive from the miner's encoding key, so a miner who holds only the raw
blob data (or another miner's copy) passes. Pattern PQ-7. Excerpt:
[`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethstorage-mining-groth16/source-excerpts.md).

The same path also depends on KZG blob openings (PQ-8, `EthStorageContract.sol` 108–155) for samples that land on a
stored blob; with `_dataHash == 0` (an empty entry) `checkInclusive` returns `decodedData == 0` without the precompile.
With 3,338 entries in a 2^22-entry shard, samples almost always land on empty entries, and the trace shows no
point-evaluation call from this contract in the last year. That mechanism is rated in
[`ethstorage-blob-kzg`](ethstorage-blob-kzg.md).

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x99f5…df33`, `version() = 0.2.1`): the path above.
- CHECKED (block 26,431,543, [`onchain-review.md`](#on-chain-reads-review15-2026-11-17)):
  EIP-1967 implementation `0x99f5cc6a…`, admin `0x654dd564…` (ProxyAdmin) whose `owner()` is Safe `0xa10d…9f3c`,
  threshold 1 of 2 owners (both EOAs); the Safe has `DEFAULT_ADMIN_ROLE` and is `treasury()`;
  `enforceMinerRole() = true`; balance 0.17725 ETH.
- CHECKED (precompile trace to March 2026, `data/agg/`): `ecpairing` with 4 pairs (Groth16), `ecadd`, `ecmul` and
  BN254-field `modexp`; 260 pre-quantum calls in the last year (`curated_contracts.csv`); no `pointEval` call.
- CHECKED (block ~26,431,608): `kvEntryCount() = 3338`, `shardEntryBits() = 22`.
- CHECKED (Xatu, any function): 94 transactions 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethstorage-mining-groth16/activity.json)).
- INFERRED: an outside attacker who is not whitelisted gains nothing: `mine` pays the `miner` argument, which must hold
  `MINER_ROLE`. The number of whitelisted miners was not enumerated.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf0193d6e…` EthStorageContractM2 | yes (1-of-2 Safe) | USD 321 (held: reward pool) | 2026-11-15 | 94 |

The held ETH is the pool that funds miner rewards (from users' storage payments); `accPrepaidAmount` is 1.47 ETH
against a `prepaidAmount` of 25.17 ETH, so the treasury cannot withdraw yet. Users' stored data is the other thing at
stake: a cheating miner keeps being paid while not storing the replica, which this finding does not value.

## Remediation

- EthStorage upgrades the implementation so the decoding proof is checked by a hash-based (STARK/FRI) verifier;
  the Safe `0xa10d…9f3c` acts through ProxyAdmin `0x654d…6372`. No protocol change needed.
- Until then the miner whitelist limits who can cheat; the 1-of-2 Safe owners are EOAs and should move to
  post-quantum signers.
- The KZG opening in `checkInclusive` (PQ-8) is a second dependency on the same path, dormant while the shard is
  nearly empty; see [`ethstorage-blob-kzg`](ethstorage-blob-kzg.md).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review15): MEDIUM -> LOW, step 5: the reward pool (contract balance, USD 321) is the measured exposure, and only whitelisted miners can be paid. The KZG (PQ-8) opening on the same path is now ethstorage-blob-kzg.

# On-chain reads (Review15, 2026-11-17)

RPC https://ethereum-rpc.publicnode.com, block 26,431,543. Proxy `0xf0193d6e8fc186e77b6e63af4151db07524f6a7a`.

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x99f5cc6ad111584c88891b4c6fff5784a46adf33` |
| EIP-1967 admin slot | `0x654dd56444856e928917549263aac6f9d6a96372` |
| ProxyAdmin `owner()` | `0xa10d87502a0d8fce45610c6028f0756383649f3c` |
| Safe `getThreshold()` / `getOwners()` | 1 / `0x6fd772e4f7129c259a3c10650a24acc61802971f` (EOA, nonce 12), `0x905d49785b3d28714a9bc7532f74c5a2228e0602` (EOA, nonce 1) |
| `hasRole(DEFAULT_ADMIN_ROLE, Safe)` | true |
| `treasury()` | `0xa10d87502a0d8fce45610c6028f0756383649f3c` |
| `enforceMinerRole()` | true |
| `accPrepaidAmount()` / `prepaidAmount()` | 1.4723 ETH / 25.1658 ETH |
| ETH balance | 0.177249 ETH |
| `version()` | 0.2.1 |
