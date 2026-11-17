---
id: scroll-plonk-verifier-bn254
title: "Scroll: a forged BN254 bundle proof finalizes a false withdraw root in ScrollChain and drains the L1 bridge (~USD 26M)"
project: scroll
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x0d2a59fd7060460f07c30c2817b4e79576da01c6"
  implementation: null
  name: OpenVmHalo2Verifier (plonkVerifier of version-10 ZkEvmVerifierPostFeynman 0xb15417122fb6e853d84e498517268d33d7301e74)
  upgradeable: "no"
  admin: none; MultipleVersionRollupVerifier 0x4cea3e866e7c57fd75cb0ca3e9f5f1151d4ead3f owner ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 can repoint (updateVerifier)
  value_usd: 26002361
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 460
- address: "0x749fc77a1a131632a8b88e8703e489557660c75e"
  implementation: null
  name: unverified Halo2 verifier (plonkVerifier of version-9 ZkEvmVerifierPostFeynman 0x4af7f3abd780fbd319c4356a219100a45f85ddb5)
  upgradeable: "no"
  admin: none; still registered as latestVerifier(9); ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 can repoint
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-25
  txs_30d: 0
- address: "0x8c1b52757b5c571adcb5572e992679d4d48e30f7"
  implementation: null
  name: unverified PLONK verifier (plonkVerifier of version-4 ZkEvmVerifier 0xcaecee2e815e7f758c2477f900afa14bddce54b3)
  upgradeable: "no"
  admin: none; registered as latestVerifier(4), not used by current finalizations
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-16
  txs_30d: 0
- address: "0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6"
  implementation: null
  name: unverified Halo2 verifier (OpenVM era, no longer a latestVerifier)
  upgradeable: "no"
  admin: none; not a latestVerifier for any version at block 26,431,492
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-08-08
  txs_30d: 0
- address: "0xd1638c0c7bd6bf49d655d855d353ac8b4f949582"
  implementation: null
  name: Halo2Verifier (plonkVerifier of version-6 ZkEvmVerifier 0x0112315fa1c81c35ac9a477e161b52ae4d1466b3)
  upgradeable: "no"
  admin: none; registered as latestVerifier(6), not used by current finalizations
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-22
  txs_30d: 0
- address: "0x9f66505cb1626d06b50ef2597f41de6686e8f79a"
  implementation: null
  name: unverified Halo2 verifier (plonkVerifier of ZkEvmVerifierPostEuclid 0x33996cc9eee2dc20b10b8e57d313d0facc7a0828; no longer a latestVerifier)
  upgradeable: "no"
  admin: none; not a latestVerifier for any version at block 26,431,704
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-05-26
  txs_30d: 0
- address: "0x39854df30b3482ef546f68b8981fae5a2c426ea4"
  implementation: null
  name: unverified Halo2 verifier (plonkVerifier of ZkEvmVerifierPostEuclid 0xc084a6de8b0f2742396572d6f110ec87ca9329ba, version 7, and ZkEvmVerifierPostFeynman 0xa8d4702aa5c09af5dd1323e1842a43789021f485, version 8)
  upgradeable: "no"
  admin: none; still registered as latestVerifier(7) and latestVerifier(8) at block 26,431,788; ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 can repoint
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-16
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Scroll: ScrollOwner 0x798576400f7d662961ba15c6b3f3d813447a26a6 (DEFAULT_ADMIN_ROLE: TimelockController 0x3f9041350b661c74c6cbe440c8bd6bc4c168a9fd, 3-day delay) calls MultipleVersionRollupVerifier 0x4cea3e866e7c57fd75cb0ca3e9f5f1151d4ead3f updateVerifier with a hash-based verifier"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/scroll-plonk-verifier-bn254/classification.jsonl
  - evidence/scroll-plonk-verifier-bn254/onchain.json
  - evidence/scroll-plonk-verifier-bn254/activity.json
  - evidence/scroll-plonk-verifier-bn254/source-excerpts.md
  - evidence/scroll-plonk-verifier-bn254/escrow.json
  - evidence/scroll-plonk-verifier-bn254/notes.md
  - evidence/scroll-plonk-verifier-bn254/attribution-9f66505c.json
  - evidence/scroll-plonk-verifier-bn254/attribution-39854df3.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_3.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x9f66505c
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review13 (0x9f66505c deployer, wrapper and caller trace; Scroll verifier registry reads)
  ref: evidence/scroll-plonk-verifier-bn254/attribution-9f66505c.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  who: Review14 (verified source of the current verifier, verifier registry and bridge reads)
  ref: evidence/scroll-plonk-verifier-bn254/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x39854df3
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review01 (0x39854df3 creator, last caller trace, bytecode constants, verifier registry reads)
  ref: evidence/scroll-plonk-verifier-bn254/attribution-39854df3.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [scroll-blob-kzg]
---

## Summary

ScrollChain finalizes Scroll batches, including the L2 withdraw root that the L1 bridge pays out against, only after a
bundle proof passes a Halo2/KZG verifier on BN254. With the BN254 setup trapdoor, an attacker can produce a proof of a
false state transition and a withdraw root that pays them the L1 bridge's ~USD 26.0M (measured 2026-11-17). The
verifiers are immutable, but ScrollChain reaches them through MultipleVersionRollupVerifier, whose timelocked owner can
register new ones: rated MEDIUM (step 4: a new verifier the consumer points at).

## Mechanism

- `ScrollChain.finalizeBundlePostEuclidV2` (OnlyProver) and `commitAndFinalizeBatch` (anyone in enforced mode) call
  `IRollupVerifier(verifier).verifyBundleProof(version, batchIndex, aggrProof, publicInputs)`; the public inputs
  include `postStateRoot` and `withdrawRoot`. `verifier` is the immutable MultipleVersionRollupVerifier `0x4cea…4ead3f`.
- `MultipleVersionRollupVerifier.getVerifier(version, batchIndex)` returns `latestVerifier[version]`; the ZkEvmVerifier
  wrapper forwards to its `plonkVerifier()`.
- Current path (tx `0x19c969ef…`, block 26,431,001): wrapper `0xb1541712…` (ZkEvmVerifierPostFeynman, version 10) →
  `OpenVmHalo2Verifier.verify(publicValues, proofData, appExeCommit, appVmCommit)` at `0x0d2a59fd…`, which self-calls
  the snark-verifier `Halo2Verifier` fallback: `ecmul`/`ecadd` MSMs and the final pairing
  `staticcall(gas(), 0x8, 0x64a0, 0x180, 0x64a0, 0x20)` (Halo2Verifier.sol line 2120).
- MultipleVersionRollupVerifier still has verifiers registered for versions 4, 6, 7, 8 (`0x39854df3…`) and 9
  (`0x749fc77a…`) besides the live version 10; `0x7f1a3e12…` and `0x9f66505c…` (Euclid wrapper `0x33996cc9…`) are no
  longer registered for any version.
- Pattern PQ-7 (KZG-based PLONK/Halo2 on BN254; trusted-setup trapdoor recoverable from the SRS).

## Evidence

- CHECKED (Blockscout verified source of `0x0d2a59fd…`, read 2026-11-17): `OpenVmHalo2Verifier` + `Halo2Verifier`
  with the BN254 pairing call ([`notes.md`](../evidence/scroll-plonk-verifier-bn254/notes.md)).
- CHECKED (Sourcify verified source of MultipleVersionRollupVerifier `0x4cea…` and ScrollChain implementation
  `0x0a2070…`): `getVerifier`, `verifyBundleProof`, `updateVerifier` (onlyOwner).
- CHECKED (cast at block 26,431,492): `ScrollChain.verifier()` = `0x4cea…`; `latestVerifier(4..10)` and each
  wrapper's `plonkVerifier()`; `owner()` of `0x4cea…` = ScrollOwner `0x7985…26a6`; ScrollOwner
  `DEFAULT_ADMIN_ROLE` member TimelockController `0x3f90…a9fd`, `getMinDelay()` = 259200
  ([`escrow.json`](../evidence/scroll-plonk-verifier-bn254/escrow.json)).
- CHECKED (Blockscout transactions and internal calls, 2026-11-17): 460 successful `finalizeBundlePostEuclidV2`
  transactions in blocks 26,208,000–26,423,999, the first and last both routed to `0x0d2a59fd…`.
- INFERRED (bytecode only): `0x749fc77a…`, `0x8c1b5275…`, `0x7f1a3e12…` are snark-verifier Halo2/PLONK verifiers
  (fallback-only, BN254 constants, `ecpairing` in the trace); the trace attributes their calls to ScrollChain
  finalizations ([`classification.jsonl`](../evidence/scroll-plonk-verifier-bn254/classification.jsonl)).
- CHECKED (Review13, Blockscout and cast at block 26,431,704): `0x9f66505c…` was created on 2025-04-23 by EOA
  `0x454e0a55…` together with L1ScrollMessenger implementation `0x84791281…` and ZkEvmVerifierPostEuclid
  `0x33996cc9…`, whose `plonkVerifier()` is `0x9f66505c…`; its 197 trace-year transactions (blocks 22,345,417 to
  22,564,303) are ScrollChain `finalizeBundlePostEuclidV2` calls; it is not the latest verifier for any version 0–10
  ([`attribution-9f66505c.json`](../evidence/scroll-plonk-verifier-bn254/attribution-9f66505c.json)). Bytecode only;
  the draft's "identical code to `0x39854df3…`" is wrong (runtime code hashes differ).
- CHECKED (Review01, precompile corpus, Blockscout and cast at block 26,431,788): `0x39854df3…` was created by
  `0xb1223481…` (tx `0xd899aecd…`); it made 4,367 `ecpairing`, 91,707 `ecadd`/`ecmul` and 13,101 `modexp` calls in
  blocks 23,105,047–24,023,851, the last (tx `0x0c185749…`, 2025-12-16) a ScrollChain `finalizeBundlePostEuclidV2`;
  its runtime code (18.5 KB) contains the BN254 base-field modulus 7 times and the scalar-field modulus 4 times;
  `latestVerifier(7)` = (364,588, `0xc084a6de…`) and `latestVerifier(8)` = (0, `0xa8d4702a…`), both with
  `plonkVerifier()` = `0x39854df3…`
  ([`attribution-39854df3.json`](../evidence/scroll-plonk-verifier-bn254/attribution-39854df3.json)). Bytecode only.
  Whether ScrollChain would still finalize a version-7 or 8 batch at its current index was not checked.
- CHECKED (on-chain read at block 26,431,214): none of the verifiers holds ETH or tokens
  ([`onchain.json`](../evidence/scroll-plonk-verifier-bn254/onchain.json)).

## Impact and exposure

| Contract | Role now | Upgradeable | Exposed (escrow) | Last active | 30-day txs |
|---|---|---|---|---|---|
| `0x0d2a59fd…` OpenVmHalo2Verifier | latest, version 10 | no (repointable) | USD 26.0M | 2026-11-16 | 460 |
| `0x749fc77a…` Halo2 verifier | registered, version 9 | no (repointable) | same escrow | 2026-06-25 | 0 |
| `0x8c1b5275…` PLONK verifier | registered, version 4 | no | — | 2025-04-16 | 0 |
| `0x7f1a3e12…` Halo2 verifier | unregistered | no | — | 2025-08-08 | 0 |
| `0xd1638c0c…` Halo2Verifier | registered, version 6 | no | — | 2025-04-22 | 0 |
| `0x9f66505c…` Halo2 verifier (Euclid) | unregistered | no | — | 2025-05-26 | 0 |
| `0x39854df3…` Halo2 verifier (Euclid/Feynman) | registered, versions 7 and 8 | no (repointable) | same escrow, if a v7/8 batch is still finalizable | 2025-12-16 | 0 |

Escrow: the L1 bridge that pays out against finalized withdraw roots (routing from L1GatewayRouter `0xf8b1…1fd6`):
L1ScrollMessenger `0x6774bcbd…b367` 9,539.6 ETH (USD 17.31M), L1StandardERC20Gateway `0xd8a791fe…f8f9` USD 4.43M,
L1USDCGateway `0xf1af3b23…5c7b` USD 3.91M, wstETH gateway `0x6625c633…f504` USD 0.30M, DAI gateway `0x67260a8b…f515`
USD 56k: USD 26.0M on 2026-11-17, a lower bound. Trace-year pairing calls: `0x749fc77a…` 3,223, `0x8c1b5275…` 835,
`0x7f1a3e12…` 476, `0xd1638c0c…` 195, `0x9f66505c…` 197, `0x39854df3…` 4,367 (`data/report/curated_contracts.csv`,
`txs_y1`; `data/agg/y1_tx_caller.parquet`).

## Remediation

- Replace the BN254 outer wrap with a hash-based verifier (verify OpenVM's STARK/FRI proof directly, or a post-quantum
  wrapper), deploy it behind a new ZkEvmVerifier, and have ScrollOwner `0x7985…26a6` call
  `MultipleVersionRollupVerifier(0x4cea…).updateVerifier(version, startBatchIndex, verifier)`. Changes pass the
  3-day timelock `0x3f90…a9fd`.
- No protocol change needed. Users can only withdraw to L1.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (ScrollOwner repoints MultipleVersionRollupVerifier). Added the live verifier `0x0d2a59fd…` (created 2026-09-15, not in the trace); escrow measured at USD 26.0M; listed the verifiers still registered for older versions.
- 2026-11-17 merge (Review14): `unidentified-9f66505c-snark-verifier` merged into this finding on Main's instruction: contract `0x9f66505c…`, its evidence (classification row, on-chain and activity entries, source-excerpt header, `attribution-9f66505c.json`) and sources moved here. Its history: 2026-11-04 classified (hand classification pass); 2026-11-17 created by `scripts/15_findings.py`, rated LOW (step 1: last used 2025-05-26, holds nothing); 2026-11-17 review (Review13): LOW kept, step 1; identified as Scroll's Euclid verifier (deployer session, wrapper `plonkVerifier()`, ScrollChain callers), project unidentified-9f66505c -> scroll. This finding's MEDIUM is unchanged.
- 2026-11-17 merge (Review01): `unidentified-39854df3-snark-verifier` merged into this finding on Main's instruction: contract `0x39854df3…`, its evidence (classification row, on-chain and activity entries, source-excerpt header, `attribution.json` as `attribution-39854df3.json`) and sources moved here. Its history: 2026-11-04 classified (hand classification pass); 2026-11-17 created by `scripts/15_findings.py`, rated MEDIUM (step 4: the consumer's admin points at a new verifier); 2026-11-17 review (Review01): MEDIUM kept, step 4; identified as Scroll's version-7/8 bundle verifier, still registered in MultipleVersionRollupVerifier; project unidentified-39854df3 -> scroll; status candidate -> confirmed (bytecode plus registry reads). This finding's MEDIUM is unchanged.
