---
id: zksync-blob-kzg
title: "ZKsync (Matter Labs): with the KZG trapdoor a ZK chain's committer could claim blob data it never published, through the shared RollupL1DAValidator contracts; calldata DA is the fallback"
project: zksync
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0x1c715018c5565eacc758236d4a9a760162a84cbd"
  implementation: null
  name: RollupL1DAValidator (ZKsync Era, Sophon, Abstract, Lens)
  upgradeable: "no"
  admin: "none (immutable); each chain's admin selects the DA validator pair with setDAValidatorPair on its diamond (ZKsync Era: ChainAdmin 0x2cf3bd6a9056b39999f3883955e183f655345063, owner Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828, 4 of 7)"
  value_usd: 84711012
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: null
  txs_30d: null
- address: "0x72213dfe8ca61b0a782970dcfebfb877778f9119"
  implementation: null
  name: RollupL1DAValidator (ZERO Network, zkXPLA, ZKsync Gateway and chains 1345, 2904)
  upgradeable: "no"
  admin: "none (immutable); each chain's admin selects the DA validator pair with setDAValidatorPair on its diamond"
  value_usd: 407778
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 1471
families: []
fix:
  layer: onchain-config
  who_acts: "each ZK chain's operator (commits with PubdataSource.Calldata instead of Blob) or chain admin (setDAValidatorPair to a calldata-only validator); for ZKsync Era the ChainAdmin 0x2cf3bd6a9056b39999f3883955e183f655345063 (Safe 0x4e4943346848c4867f81dfb37c4ca9c5715a7828); a post-quantum blob scheme needs an Ethereum protocol change"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/zksync-blob-kzg/classification.jsonl
  - evidence/zksync-blob-kzg/onchain.json
  - evidence/zksync-blob-kzg/activity.json
  - evidence/zksync-blob-kzg/source-excerpts.md
  - evidence/zksync-blob-kzg/zk-stack-state.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify sources of both validators; Bridgehub and diamond reads at block 26,431,458; L1AssetTracker chain balances
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [zksync-plonk-fflonk-verifier, zksync-lite-plonk-verifier, abstract-blob-kzg]
---

## Summary

ZK Stack chains that post data in EIP-4844 blobs bind each blob to their batch with a KZG point-evaluation opening
checked in a shared `RollupL1DAValidator`. With the KZG ceremony trapdoor, a chain's committer could open a blob
commitment to data it never published, so the batch's state proof would rest on data nobody can download: the chain's
users could not reconstruct state, and funds would be stuck. Only the permissioned committer submits batches, and the
SNARK still checks the state transition, so nothing is stolen through this check. The chains using these validators
have USD 85.1M in ETH and USDC on L1 (Abstract excluded; it is in `abstract-blob-kzg`). Rated LOW: step 4: the
deployed validator already accepts calldata DA, which the operator can choose per batch (or the chain admin can make
the only option with a calldata-only validator pair), and a forged opening only withholds data.

## Mechanism

- `checkDA` (`RollupL1DAValidator.sol` line 58) is called by a chain's diamond when a batch is committed. The first
  byte of the operator's DA input picks `PubdataSource.Blob` (line 76) or `PubdataSource.Calldata` (line 78).
- Blob path: `_processBlobDA` → `_getPublishedBlobCommitment` (line 105) → `_pointEvaluationPrecompile` calls
  precompile 0x0a with the versioned hash, opening point, claimed value, commitment and proof (line 189) and requires
  the BLS modulus as result. `publishBlobs` (line 29) pre-registers commitments the same way. The resulting
  `blobsOpeningCommitments` go into the batch commitment the SNARK proof covers.
- Calldata path: `_processCalldataDA` (`CalldataDA.sol` line 86) checks the full pubdata against the hash from the
  L2 DA validator, with no KZG.
- A chain's admin can also replace the DA validator pair (`setDAValidatorPair` on the diamond's AdminFacet); several
  chains already use calldata-only or validium validators (table below).
- Pattern PQ-8. The forged opening breaks data availability, not validity.

## Evidence

- CHECKED (verified source on Sourcify, both addresses, contract `RollupL1DAValidator`): the paths and line numbers
  above (0x1c715018… is a newer build with the same functions).
- CHECKED (block 26,431,458): `Bridgehub.getAllZKChainChainIDs()` lists 22 chains; `getDAValidatorPair()` on each
  diamond: 0x1c715018… for chains 324, 50104, 2741, 232; 0x72213dfe… for 543210, 1345, 2904, 375, 9075; the others
  use ValidiumL1DAValidator (0x907b3040…, 0xac0f6bf7…), AvailL1DAValidator (0x8f50d93b…) or
  BlobsL1DAValidatorZKsyncOS (0x5ec30c00…, which checks `blobhash` but makes no point-evaluation call)
  ([`zk-stack-state.json`](../evidence/zksync-blob-kzg/zk-stack-state.json)).
- CHECKED (`L1AssetTracker` 0x7fd8b995… `chainBalance(chainId, assetId)` for ETH and USDC, block 26,431,458; ETH
  USD 1,811.62): see the table; `settlementLayer(chainId)` = 1 (Ethereum) for every chain.
- CHECKED (Xatu, any function): 0x72213dfe… had 1,471 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-10
  ([`activity.json`](../evidence/zksync-blob-kzg/activity.json)); `curated_contracts.csv`: 54,354 point-evaluation
  calls in the last year. 0x1c715018… was deployed after the trace window; its activity was not measured.
- INFERRED: chain names from chainid.network (324 ZKsync Era, 50104 Sophon, 2741 Abstract, 232 Lens, 543210 ZERO
  Network, 375 zkXPLA); 9075 is the ZKsync Gateway (ZKsync docs), 1345 and 2904 have no registry entry.

## Impact and exposure

| Contract | Chains | ETH + USDC on L1 (2026-11-17) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1c715018…` RollupL1DAValidator | 324, 50104, 232 (and 2741, counted in `abstract-blob-kzg`) | $84.71M | not measured | not measured |
| `0x72213dfe…` RollupL1DAValidator | 543210, 1345, 2904, 375, 9075 | $0.41M | 2026-11-10 | 1,471 |

- Escrow: all chains' L1 funds sit in the shared `L1NativeTokenVault` 0xbed1eb542f9a5aa6419ff3deb921a372681111f6
  (USD 127.05M in total on 2026-11-17, Blockscout), with per-chain limits in `L1AssetTracker` 0x7fd8b995…. The values
  above are ETH plus USDC chain balances only (other tokens per chain not read), so they are lower bounds of what
  would be locked. ZKsync Era alone: 35,435 ETH and 20.38M USDC.
- Impact is `funds-locked`: the committer is permissioned (ValidatorTimelock), and the ZK proof still enforces valid
  state transitions; a forged opening hides the data, it does not create value.

## Remediation

- Fallback available now: operators commit with `PubdataSource.Calldata` (same validator), or chain admins set a
  calldata-only validator pair. This costs more gas but removes the KZG dependency.
- Long term: post-quantum data availability in Ethereum (a hash-based blob commitment) would let chains keep blobs;
  that needs a protocol change, but removing the KZG dependency does not, so `protocol_change` is `not-needed`.
- Who acts: each chain's operator or admin; for ZKsync Era the ChainAdmin 0x2cf3bd6a… owned by Matter Labs Safe
  0x4e494334… (4 of 7).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review06): HIGH -> MEDIUM, step 4 (revised rubric): `checkDA` accepts calldata DA and chain admins can switch DA validators, so no protocol change is needed to drop KZG. Impact funds-loss -> funds-locked (only the committer can submit; the SNARK still checks validity). Added the live validator 0x1c715018… (Era, Sophon, Abstract, Lens); escrow measured from L1AssetTracker chain balances.
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4: the deployed `RollupL1DAValidator.checkDA` already accepts `PubdataSource.Calldata`, which the operator chooses per batch (the chain admin can also set a calldata-only validator pair), and a forged opening only withholds data (funds-locked); `protocol_change` helps -> not-needed.
