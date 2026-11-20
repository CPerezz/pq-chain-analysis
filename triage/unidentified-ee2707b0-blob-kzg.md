---
id: unidentified-ee2707b0-blob-kzg
title: "Unidentified blob validium prototype (operator 0xd5c648ba, 3 contracts): the operator posts batches against KZG blob openings, so a forged opening could hide batch data and lock deposits; ~$3 held"
status: candidate
severity: HIGH
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42"
  implementation: null
  name: unverified batch/exit contract (postBatch, proveBatch, settleBatch, exitWithProof)
  upgradeable: config-only
  admin: "operator 0xd5c648ba92b758220333f8cb5438f408efa86638 (EIP-7702-delegated EOA): transferOperator, swapVerifier, swapExitVerifier, freeze"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-03-08
  txs_30d: 0
- address: "0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2"
  implementation: null
  name: unverified batch/exit contract (same code as 0xee2707b0)
  upgradeable: config-only
  admin: "operator 0xd5c648ba92b758220333f8cb5438f408efa86638 (EIP-7702-delegated EOA): transferOperator, swapVerifier, swapExitVerifier, freeze"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-03-09
  txs_30d: 0
- address: "0x6666db78b94fce223c618a7082db8ebf77f01a1b"
  implementation: null
  name: unverified batch/exit contract (earlier build)
  upgradeable: config-only
  admin: "operator 0xd5c648ba92b758220333f8cb5438f408efa86638 (EIP-7702-delegated EOA): transferOperator, swapVerifier, swapExitVerifier, freeze"
  value_usd: 1
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-03-07
  txs_30d: 0
families: []
fix:
  layer: protocol
  who_acts: "Ethereum protocol (post-quantum data availability), or the operator 0xd5c648ba92b758220333f8cb5438f408efa86638 redeploying with calldata data availability; no fallback found in the unverified bytecode"
  protocol_change: required
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ee2707b0-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review17 (bytecode selectors and state reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ee2707b0-blob-kzg/review-notes.md
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: []
---

## Summary

Three unverified contracts deployed by the same operator, `0xd5c648ba…`, implement a small validium-style system:
the operator posts batches with an EIP-4844 blob opening (one point-evaluation call each), batches are proven with a
SNARK verifier and settled, and users deposit, claim withdrawals or force-exit. Only the operator can post batches, so
a forged KZG opening would let the operator commit to batch data nobody can read (withholding: deposits locked), not
let an outsider take funds. No calldata fallback can be established from the bytecode, so fixability is unknown and
rated as no fallback (step 6, HIGH); the contracts hold about $1 each, which lowers it to MEDIUM (step 5).

## Mechanism

- `postBatch(header, prevHeader)` is operator-only (an `eth_call` from another address reverts `Unauthorized`). Each
  contract made exactly one call to the point-evaluation precompile (0x0a), consistent with opening the batch's blob
  commitment at posting time (PQ-8). The exact use of the opening cannot be read without source.
- `proveBatch(header, proof)` and `exitWithProof(…, proof)` call `batchVerifier()` / `exitVerifier()`, unverified
  contracts with a single `Verify(bytes,uint256[])` entry and BN254 field constants (a pairing SNARK, PQ-7, not part
  of this finding). The operator can replace them with `swapVerifier` / `swapExitVerifier`.
- `triggerForceExit`, `forceExitMode`, `freeze` and `reclaimDeposits` exist; how force exits depend on posted batch
  data is not readable from bytecode.

## Evidence

- CHECKED (bytecode, latest block 2026-11-17): selectors listed in [`review-notes.md`](#review-reads-unidentified-ee2707b0-blob-kzg-2026-11-17-review17);
  `0xf49c2c07…` and `0xee2707b0…` share runtime code.
- CHECKED (state reads, latest block): `operator()` = `0xd5c648ba…` on all three; each has `nPosted` 1, `nProven` 0,
  `nSettled` 0, `totalDeposits` 1; last post 2026-03-04/05; not frozen.
- CHECKED (`eth_call`): `postBatch` from a non-operator reverts `Unauthorized`.
- CHECKED (block 26,431,214): ~$1 USDT held per contract, no proxy ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ee2707b0-blob-kzg/onchain.json)).
- CHECKED (precompile trace): one point-evaluation transaction per contract (`studies/top-callers-classification/results/curated_contracts.csv`); no
  transactions 2026-10-16 to 2026-11-16 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-ee2707b0-blob-kzg/activity.json)).
- CHECKED (Blockscout): all three created by `0xd5c648ba…`, an EIP-7702-delegated EOA (delegate `0x868f2d39…`,
  unverified) with no name or tag; project not identified.
- INFERRED: the point evaluation ties the posted blob to the batch; with source unavailable, whether the opening feeds
  the proof's public inputs (which would make it funds-loss) is not established.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xee2707b0…` batch/exit contract | config-only | $1 | 2026-03-08 | 0 |
| `0xf49c2c07…` batch/exit contract | config-only | $1 | 2026-03-09 | 0 |
| `0x6666db78…` batch/exit contract (earlier build) | config-only | $1 | 2026-03-07 | 0 |

The contracts hold their own deposits (one deposit each, ~$1). This looks like a test deployment: one batch posted,
none proven or settled.

## Remediation

- Operator: a deployment that accepts batch data as calldata (no point evaluation), or a post-quantum DA commitment
  once Ethereum offers one; the SNARK verifiers should move to a hash-based (STARK/FRI) verifier via
  `swapVerifier`/`swapExitVerifier`.
- The operator key is a single ECDSA key (EIP-7702 EOA) controlling posting and verifier swaps; it would also need a
  post-quantum account.
- Protocol: post-quantum data availability replaces KZG blob commitments.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review17): HIGH -> MEDIUM, step 5: under $50k held (~$3 across the three contracts, measured); steps 4/6 give HIGH because no calldata fallback can be established from unverified bytecode. Impact funds-loss -> funds-locked: only the operator posts blob commitments (non-operator `postBatch` reverts `Unauthorized`). Project still unidentified.
- 2026-11-19: MEDIUM -> HIGH, step 5 removed (value no longer lowers a rating); step 4 gives HIGH.

# Source excerpts: unidentified-ee2707b0-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xf49c2c070317a7c1a32f1eacbcff70c5d93f3fe2`

No verified source on Sourcify or Blockscout.


## Contract `0x6666db78b94fce223c618a7082db8ebf77f01a1b`

No verified source on Sourcify or Blockscout.


## Contract `0xee2707b08f7fc89dad3a78fcaf98294e2d5acf42`

No verified source on Sourcify or Blockscout.

# Review reads: unidentified-ee2707b0-blob-kzg (2026-11-17, Review17)

No verified source on Sourcify or Blockscout for any of the three contracts or their verifiers.

Bytecode (latest block, 2026-11-17, publicnode):

- `0xf49c2c07…` and `0xee2707b0…` have identical runtime code (md5 28045a02…); `0x6666db78…` differs (older build).
- Selectors resolved with the openchain signature database: `postBatch((uint64,uint32,uint64,uint64,uint32,bytes32,
  bytes32,uint256,bytes),(uint64,uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,uint256,bytes32))`,
  `proveBatch(…,bytes)`, `settleBatch(…,bytes)`, `revokeBatches`, `exitWithProof(uint32,uint8,uint64,bytes)`,
  `triggerForceExit()`, `forceExitMode()`, `canForceExit()`, `freeze()`, `unfreeze()`, `frozen()`,
  `deposit(address)`, `depositToken(address,…)`, `reclaimDeposits`, `claimWithdrawal(uint8,…)`,
  `swapVerifier(address)`, `swapExitVerifier(address)`, `batchVerifier()`, `exitVerifier()`,
  `transferOperator(address)`, `operator()`, `setRateLimit(uint256)`, `addCurrency`, `modifyCurrency`, `merkleRoot()`.

State reads (latest block):

| Contract | operator | batchVerifier | exitVerifier | nPosted | nProven | nSettled | totalDeposits | frozen / forceExitMode | lastPostTime |
|---|---|---|---|---|---|---|---|---|---|
| `0xf49c2c07…` | `0xd5c648ba…` | `0x599c0891…` | `0x599c0891…` | 1 | 0 | 0 | 1 | false / false | 1772700239 (2026-03-05) |
| `0x6666db78…` | `0xd5c648ba…` | `0xe4bdeb4a…` | `0xbb7ebc1b…` | 1 | 0 | 0 | 1 | false / false | 1772593379 (2026-03-04) |
| `0xee2707b0…` | `0xd5c648ba…` | `0x599c0891…` | `0x599c0891…` | 1 | 0 | 0 | 1 | false / false | 1772698163 (2026-03-05) |

- `eth_call postBatch(…)` from `0x…dead` reverts `Unauthorized`; from the operator it reverts `BatchChainBroken`
  (passes the caller check): only the operator posts batches and their blob commitments.
- Verifiers `0x599c0891…` and `0xe4bdeb4a…` (unverified): one external selector `Verify(bytes,uint256[])` and the
  BN254 scalar and base field moduli in bytecode: a pairing-based SNARK verifier (PQ-7), a separate mechanism.
- Operator `0xd5c648ba92b758220333f8cb5438f408efa86638`: code `0xef0100868f2d39…` (EIP-7702 delegation to
  `0x868f2d39449bdc83c9aa92620b182a8affc049f1`, unverified), nonce 267. Blockscout: creator of all three contracts;
  last own transactions in April 2026 (a `bridge` call to MetaBridge `0x0439e60f…`); no name, tag or ENS.
- Holdings (onchain.json, block 26,431,214): USDT ~$1 per contract.
- `data/report/curated_contracts.csv`: one point-evaluation (`kzg`) transaction per contract.
