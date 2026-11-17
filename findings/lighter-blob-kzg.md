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
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-blob-kzg
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-blob-kzg/notes.md
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
  ([`notes.md`](#review-notes-lighter-blob-kzg-2026-11-17)). The resolved selectors include
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
  source on Sourcify or Blockscout ([`notes.md`](#review-notes-lighter-blob-kzg-2026-11-17)).
- CHECKED (on-chain read, block 26,431,454): `getMaster()` of the proxy is UpgradeGatekeeper `0x94da8a99…`; its master is
  Safe `0x97a90ec9…` (3 of 5); security council Safe `0x92b12c9d…` (4 of 7); notice period 1,814,400 s; upgrade status
  Idle; `desertMode()` false.
- CHECKED (on-chain read, block 26,431,214): holdings 11,171.69 ETH plus $887.5M in tokens (USDC $471.2M, LIT $411.4M)
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-blob-kzg/onchain.json)).
- CHECKED (Xatu, any function): 73,780 transactions called the contract 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lighter-blob-kzg/activity.json)).
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review11): HIGH -> MEDIUM, step 4: under the revised rubric a KZG dependency is HIGH only without a fallback the admin can switch to; the gatekeeper can upgrade ZkLighter to calldata data availability without a protocol change. Impact funds-loss -> funds-locked (only validators commit; a forged opening withholds data, the state transition stays proven). Evidence level source-read -> bytecode (implementation unverified; BLOBHASH and 0x0a call read from bytecode). Admin traced to the master Safe and security council.

# Source excerpts: lighter-blob-kzg

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7` — Proxy (verified source via sourcify)

## Implementation `0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f`

No verified source on Sourcify or Blockscout.

# Review notes: lighter-blob-kzg (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454 unless stated.

## ZkLighter implementation bytecode (unverified)

- Proxy `0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7`: `getTarget()` = `0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f`,
  `getMaster()` = UpgradeGatekeeper `0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67`. `desertMode()` = false.
- Implementation not verified on Sourcify or Blockscout. `cast disassemble` of its runtime code (22,249 bytes):
  - two `BLOBHASH` opcodes (offsets 0x52ab, 0x5311);
  - `PUSH1 0x0a; GAS; STATICCALL` at offset 0x5542 (call to the point-evaluation precompile), result checked with
    `ISZERO`/`JUMPI` right after.
- `cast selectors --resolve` on the implementation: `commitBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes),(…))`,
  `verifyBatch(…,bytes)`, `executeBatches`, `revertBatches`, `activateDesertMode()`, `performDesert(uint48,address,uint16,uint128,bytes)`,
  `updateStateRoot`, `validiumRoot()`, `deposit`, `withdrawPendingBalance`. The selector of Governance
  `isActiveValidator(address)` (`0x40550a1c`) occurs once in the bytecode.
- Storage of the proxy: slot 4 = verifier proxy `0xac3ce44b6ff4e402858c99d5699ff63131572baa`, slot 5 = DesertVerifier
  `0x975210588389526a3a1def1628e7a4d7abdfd121`, slot 6 = Governance proxy `0xa464da0b43f80ee3ffc4795cbbfc78472b5c81a1`.

## Who can change it

- UpgradeGatekeeper `0x94da8a99…` (verified, Matter Labs zkSync gatekeeper adapted by Lighter):
  `getMaster()` = Safe `0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2` (Safe 1.4.1, threshold 3 of 5 owners:
  `0x2994d343b6b17ec23e9e4a08082184fd43f763a3`, `0x67d6c2569ab98a1f535e36b3bab1fbd825fa536e`,
  `0xa0b3781b830df57b1f018c434c58551c2fc6b3af`, `0x6fee6cdd595d12ec6cd1803474b3615f1d2fb9ed`,
  `0xf65f409d8f3fa3635287783256394d7eb7ad7835`).
- `securityCouncilAddress()` = Safe `0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045` (Safe 1.4.1, 4 of 7); it can cut the
  notice period to zero (`cutUpgradeNoticePeriod`).
- `approvedUpgradeNoticePeriod()` = 1,814,400 s (3 weeks); `upgradeStatus()` = 0 (Idle); `versionId()` = 81.
- `managedContracts(0..2)` = Governance `0xa464da0b…`, verifier `0xac3ce44b…`, ZkLighter `0x3b4d794a…`.
- Governance `networkGovernor()` = the same 3-of-5 Safe `0x97a90ec9…`.
- Upgrades are refused while `desertMode()` is true (`isReadyForUpgrade`).

## Holdings

From `onchain.json` (block 26,431,214): 11,171.69 ETH and $887.5M in tokens (USDC $471.2M, LIT $411.4M, XAUT $4.1M,
…), $907.8M total at ETH = $1,811.62.
