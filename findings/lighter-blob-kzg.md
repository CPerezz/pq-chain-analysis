---
id: lighter-blob-kzg
title: "Lighter: a quantum attacker with the KZG setup trapdoor and a validator key can commit zkLighter batches whose blob does not hold the data, freezing exits for the $908M in the rollup"
project: lighter
status: confirmed
severity: MEDIUM
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7"
  implementation: "0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f"
  name: Proxy → ZkLighter (implementation unverified)
  upgradeable: "yes"
  admin: "UpgradeGatekeeper 0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67, master Safe 0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2 (3 of 5), 3-week notice that security council Safe 0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045 (4 of 7) can cut; read at block 26,431,454"
  value_usd: 907780551
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 73780
families: []
fix:
  layer: contract-upgrade
  who_acts: "Lighter, through UpgradeGatekeeper 0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67 (master Safe 0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2, 3 of 5): upgrade ZkLighter to commit batch data as calldata, or to a post-quantum blob commitment once Ethereum offers one"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/lighter-blob-kzg/classification.jsonl
  - evidence/lighter-blob-kzg/onchain.json
  - evidence/lighter-blob-kzg/activity.json
  - evidence/lighter-blob-kzg/source-excerpts.md
  - evidence/lighter-blob-kzg/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/lighter-blob-kzg/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [lighter-plonk-verifier]
---

## Summary

zkLighter's rollup contract binds each committed batch to an EIP-4844 blob by opening the blob's KZG commitment with
the point-evaluation precompile (PQ-8). With the KZG ceremony trapdoor, an opening for data that is not in the blob
verifies, so a batch can be committed whose published blob does not contain the state data the proof used; users then
cannot rebuild their balances for desert-mode exits. Only active validators commit batches, so the attacker also needs a
validator key (an ECDSA EOA, also recoverable). The $907.8M held by the contract (2026-11-17) can be frozen, not taken
through this check. Rated MEDIUM (step 4): Lighter can upgrade the contract to post batch data as calldata without a
protocol change.

## Mechanism

- `0x3b4d794a…` is Lighter's zkSync-style `Proxy`; `getTarget()` is `0x9b4a5f3c…`, which is not verified. Its bytecode
  reads `BLOBHASH` twice and makes a `STATICCALL` to precompile `0x0a` (offset 0x5542) whose result is checked
  ([`notes.md`](../evidence/lighter-blob-kzg/notes.md)). The resolved selectors include
  `commitBatch(…,bytes)`, `verifyBatch(…,bytes)`, `executeBatches`, `activateDesertMode()` and `performDesert(…)`.
- [INFERENCE from bytecode, no source] `commitBatch` checks the blob's versioned hash and a KZG opening at a challenge
  point, tying the blob to the batch commitment that `verifyBatch` later proves with the PLONK verifier
  (`lighter-plonk-verifier`). A forged opening lets the committer publish a blob that differs from the proven data. The
  state transition is still proven, so nothing is minted or taken; the data needed for `performDesert` exits is
  withheld.
- Commits are gated on Governance `isActiveValidator` (selector present in the bytecode; INFERRED that it gates
  `commitBatch`), so the attacker must be or impersonate a validator.

## Evidence

- CHECKED (precompile trace, all mainnet transactions to March 2026): this contract calls the point-evaluation precompile.
- CHECKED (bytecode, block 26,431,454): `BLOBHASH` and `STATICCALL` to `0x0a` in implementation `0x9b4a5f3c…`; no verified
  source on Sourcify or Blockscout ([`notes.md`](../evidence/lighter-blob-kzg/notes.md)).
- CHECKED (on-chain read, block 26,431,454): `getMaster()` of the proxy is UpgradeGatekeeper `0x94da8a99…`; its master is
  Safe `0x97a90ec9…` (3 of 5); security council Safe `0x92b12c9d…` (4 of 7); notice period 1,814,400 s; upgrade status
  Idle; `desertMode()` false.
- CHECKED (on-chain read, block 26,431,214): holdings 11,171.69 ETH plus $887.5M in tokens (USDC $471.2M, LIT $411.4M)
  ([`onchain.json`](../evidence/lighter-blob-kzg/onchain.json)).
- CHECKED (Xatu, any function): 73,780 transactions called the contract 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](../evidence/lighter-blob-kzg/activity.json)).
- INFERRED: that the opening binds blob data to the proven batch and that the current implementation has no calldata
  data path (`commitBatch` takes a `bytes` field whose use is not visible without source).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3b4d794a…` Proxy → ZkLighter | yes (gatekeeper, 3-week notice) | $907.8M | 2026-11-16 | 73,780 |

The rollup contract is its own escrow: the $907.8M (2026-11-17) is what users could no longer exit with if batch data is
withheld. Yearly pre-quantum count from the census: 145,399 transactions (`txs_y1`). Same project, other mechanism: the
batch proof verifier (`lighter-plonk-verifier`).

## Remediation

- Lighter (UpgradeGatekeeper master Safe `0x97a90ec9…`, 3 of 5, after the 3-week notice or a cut by the security council
  Safe `0x92b12c9d…`) upgrades ZkLighter to post batch data as calldata (hash-committed, no KZG), or to a post-quantum
  blob commitment once Ethereum provides one. No protocol change is needed for the calldata route; a post-quantum
  data-availability scheme in the protocol would remove the calldata cost.
- Upgrades are blocked once desert mode is active, so the change has to happen before an incident.
- Users cannot act on this themselves beyond withdrawing.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review11): HIGH -> MEDIUM, step 4: under the revised rubric a KZG dependency is HIGH only without a fallback the admin can switch to; the gatekeeper can upgrade ZkLighter to calldata data availability without a protocol change. Impact funds-loss -> funds-locked (only validators commit; a forged opening withholds data, the state transition stays proven). Evidence level source-read -> bytecode (implementation unverified; BLOBHASH and 0x0a call read from bytecode). Admin traced to the master Safe and security council.
