---
id: unidentified-ee2707b0-blob-kzg
title: "Unidentified blob validium prototype (operator 0xd5c648ba, 3 contracts): the operator posts batches against KZG blob openings, so a forged opening could hide batch data and lock deposits; ~$3 held"
project: unidentified-ee2707b0
status: candidate
severity: MEDIUM
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
  links:
  - evidence/unidentified-ee2707b0-blob-kzg/classification.jsonl
  - evidence/unidentified-ee2707b0-blob-kzg/onchain.json
  - evidence/unidentified-ee2707b0-blob-kzg/activity.json
  - evidence/unidentified-ee2707b0-blob-kzg/source-excerpts.md
  - evidence/unidentified-ee2707b0-blob-kzg/review-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review17 (bytecode selectors and state reads)
  ref: evidence/unidentified-ee2707b0-blob-kzg/review-notes.md
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

- CHECKED (bytecode, latest block 2026-11-17): selectors listed in [`review-notes.md`](../evidence/unidentified-ee2707b0-blob-kzg/review-notes.md);
  `0xf49c2c07…` and `0xee2707b0…` share runtime code.
- CHECKED (state reads, latest block): `operator()` = `0xd5c648ba…` on all three; each has `nPosted` 1, `nProven` 0,
  `nSettled` 0, `totalDeposits` 1; last post 2026-03-04/05; not frozen.
- CHECKED (`eth_call`): `postBatch` from a non-operator reverts `Unauthorized`.
- CHECKED (block 26,431,214): ~$1 USDT held per contract, no proxy ([`onchain.json`](../evidence/unidentified-ee2707b0-blob-kzg/onchain.json)).
- CHECKED (precompile trace): one point-evaluation transaction per contract (`data/report/curated_contracts.csv`); no
  transactions 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/unidentified-ee2707b0-blob-kzg/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review17): HIGH -> MEDIUM, step 5: under $50k held (~$3 across the three contracts, measured); steps 4/6 give HIGH because no calldata fallback can be established from unverified bytecode. Impact funds-loss -> funds-locked: only the operator posts blob commitments (non-operator `postBatch` reverts `Unauthorized`). Project still unidentified.
