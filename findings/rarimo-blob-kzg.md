---
id: rarimo-blob-kzg
title: "Rarimo ZK rollup: forged KZG blob openings on LineaRollup 0x2f3c2056 let a submitter finalize L2 state whose data was never published, stranding the rollup's ETH (~$3k); calldata submission avoids the precompile"
project: rarimo
status: confirmed
severity: MEDIUM
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0x2f3c205613d9451f88e19e011ed23775afe00c41"
  implementation: "0x37139c71a739659a079576a97507d9c1a37b9eb4"
  name: TransparentUpgradeableProxy -> LineaRollup (v6.0)
  upgradeable: "yes"
  admin: "ProxyAdmin 0xb6b6e80bd32bca86ed5d60ff6889cff5e2d4f63f owned by EOA 0xbbef10cea9eefd021069a1fc4a348c00e799b01b, which also holds DEFAULT_ADMIN_ROLE and the pause roles"
  value_usd: 3047
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-20
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Rarimo: the operators (OPERATOR_ROLE, e.g. blob submitter 0x558abe76a8258b55f14e5e16c92b6f6b087dea0e) switch to submitDataAsCalldata; EOA 0xbbef10cea9eefd021069a1fc4a348c00e799b01b (PAUSE_BLOB_SUBMISSION_ROLE) pauses blob submission on 0x2f3c205613d9451f88e19e011ed23775afe00c41"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-blob-kzg
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
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-blob-kzg/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [rarimo-plonk-verifier]
---

## Summary

The Rarimo ZK rollup (chain id 7368) posts its L2 data to Ethereum through a LineaRollup v6.0 proxy at 0x2f3c2056,
whose `submitBlobs` checks each blob with the KZG point-evaluation precompile (PQ-8). With the KZG ceremony trapdoor a
submitter can claim an evaluation the blob does not contain, so the rollup can finalize a state whose data nobody can
reconstruct; the validity proof still checks execution, so nothing is taken through this check, but the 1.68 ETH
(USD 3,047) held by the rollup can be stranded. The same contract already offers `submitDataAsCalldata`, which binds data
by keccak and needs no precompile, so the operators can switch without a protocol change: MEDIUM by step 4, LOW after
step 5 (under USD 50k).

## Mechanism

- `LineaRollup.submitBlobs(_blobSubmissions, _parentShnarf, _finalBlobShnarf)` (`OPERATOR_ROLE`, pause type
  `BLOB_SUBMISSION`) takes `blobhash(i)`, derives the evaluation point from `keccak(snarkHash, blobhash)`, and calls
  `_verifyPointEvaluation`, a `staticcall` to precompile 0x0a with `(dataHash, z, y, commitment, proof)`, requiring the
  return `(4096, BLS modulus)` (excerpt lines 420–452). The claimed `y` goes into the shnarf, which `finalizeBlocks`
  feeds to the PLONK proof's public input.
- A forged opening breaks only the link between the published blob and the data the prover executed: the circuit still
  proves a valid state transition, so the forged opening alone cannot mint or release funds. What it allows is
  finalizing a state whose transactions are not published, so users cannot build state or withdrawal proofs:
  data withholding (`funds-locked`). Taking funds needs the separate SNARK forgery
  ([`rarimo-plonk-verifier`](rarimo-plonk-verifier.md)).
- Fallback in the same contract: `submitDataAsCalldata(_submission, _parentShnarf, _expectedShnarf)` (`OPERATOR_ROLE`,
  pause type `CALLDATA_SUBMISSION`) hashes the compressed calldata with keccak and computes `y` in software
  (`_calculateY`); no pairing or KZG is involved. Neither pause type is set.
- Who can submit: the `OPERATOR_ROLE` holders (EOAs that have signed, so their keys fall to a CRQC), and, since the
  rollup has not finalized for six months (last 2026-04-28), anyone can call `setFallbackOperator` to give
  `OPERATOR_ROLE` to Multicall3 `0xca11bde0…` [INFERRED from source and dates; not executed].

## Evidence

- CHECKED (Sourcify, implementation `0x37139c71…`, LineaRollup v6.0): `submitBlobs`, `_verifyPointEvaluation`,
  `submitDataAsCalldata`, `setFallbackOperator`, pause roles.
- CHECKED (on-chain read, block 26,431,494): EIP-1967 implementation `0x37139c71…`, admin ProxyAdmin `0xb6b6e80b…`,
  ProxyAdmin `owner()` EOA `0xbbef10ce…` (no code); `0xbbef10ce…` holds `DEFAULT_ADMIN_ROLE`, `PAUSE_ALL_ROLE`,
  `PAUSE_BLOB_SUBMISSION_ROLE`, `PAUSE_FINALIZATION_ROLE`; `OPERATOR_ROLE` held by `0x3cbe03d5…`, `0x558abe76…`, and
  granted on 2025-11-11 to `0x62c5d5d8…` and `0xc29ef98e…`; `isPaused(1..8)` all false; balance 1.6818 ETH
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/rarimo-blob-kzg/review-reads.json)).
- CHECKED (Blockscout transaction list): 322 `submitBlobs` (last 2026-04-28) and 321 `finalizeBlocks` (last
  2026-04-28); the last transaction is a `sendMessage` deposit on 2026-07-20; 252 point-evaluation calls in the year to
  March 2026 (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (identification): Rarimo's docs ([network info](https://docs.rarimo.com/zk-registry/network-info/)) list
  RollupProxy `0x2f3c2056…`, Deployer and RollupSecurityCouncil `0xbbef10ce…`, FinalizationOperator `0x3cbe03d5…`,
  BlobSubmissionOperator `0x558abe76…`; Blockscout shows `0xbbef10ce…` created the proxy, ProxyAdmin, implementation,
  verifiers and TokenBridge `0x54f014a2…`.
- INFERRED: calldata submission is accepted by Rarimo's prover; the contract accepts it, but Rarimo has only used blobs.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2f3c2056…` TransparentUpgradeableProxy -> LineaRollup | yes | $3,047 (1.6818 ETH) | 2026-07-20 | 0 |

The rollup's own ETH (block 26,431,494, ETH at USD 1,811.62) is what withheld data could strand; the TokenBridge
`0x54f014a2a5cb0480a7ceda2184d3543a025e7b3f` holds 0.00011 WETH (USD 0.20). Nothing is released through the opening
itself.

## Remediation

- Post data with `submitDataAsCalldata` and pause `BLOB_SUBMISSION` (`pauseByType(4)`), until Ethereum offers
  post-quantum data availability; then adopt it by upgrading the rollup.
- Who acts: Rarimo operators (`OPERATOR_ROLE`), and EOA `0xbbef10cea9eefd021069a1fc4a348c00e799b01b`
  (pause roles; owner of ProxyAdmin `0xb6b6e80b…`). That admin is one ECDSA key that has signed on-chain, and a CRQC
  holder of it can upgrade the rollup outright; moving it to post-quantum-capable control is part of the fix.
- No protocol change is needed for the calldata path; a post-quantum blob scheme would be a protocol change.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review16): HIGH -> LOW, step 5: `submitDataAsCalldata` is an unpaused fallback in the same contract (step 4 MEDIUM under the KZG-fallback rule), and the rollup holds USD 3,047. Impact funds-loss -> funds-locked: a forged opening allows data withholding, not theft (the SNARK still checks execution). Alternative sole -> alternative-exists. Project identified as Rarimo ZK rollup (docs address book, Blockscout creator).
- 2026-11-17 integration: id renamed from `unidentified-2f3c2056-blob-kzg` (project identified).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.
