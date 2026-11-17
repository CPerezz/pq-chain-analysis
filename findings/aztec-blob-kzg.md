---
id: aztec-blob-kzg
title: "Aztec rollup: a quantum attacker who recovers the KZG ceremony trapdoor can finalize epochs whose EIP-4844 blobs do not carry the transaction data, locking about USD 81k of L2 funds held in the live versions' portals"
project: aztec
status: confirmed
severity: MEDIUM
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: sole
role: core
contracts:
- address: "0xe37a2663cc9c119ba41572c40fab0bbb23a5402f"
  implementation: null
  name: Rollup (version 2070860440, canonical since 2026-10-10)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only; blob checks fixed, `checkBlob` has no setter); replacement = new rollup version via Registry 0x35b22e09ee0390539439e24f06da43d83f90e298 and GSE 0xa92ecfd0e70c9cd5e5cd76c50af0f7da93567a4f
  value_usd: 62247
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 44053
- address: "0x91ff8bbd8ebb07893010d50a48a1609e5ebd8e34"
  implementation: null
  name: Rollup (version 4248422647, deployed 2026-06-30, still producing blocks)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only)
  value_usd: 18970
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 44350
- address: "0x603bb2c05d474794ea97805e8de69bccfb3bca12"
  implementation: null
  name: Rollup (version 0; halted, no attesters)
  upgradeable: "no"
  admin: owner Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (settings only)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: 28
families: []
fix:
  layer: new-deployment
  who_acts: Aztec Governance 0x1102471eb3378fee427121c9efcea452e4b6b75e (governance vote) registers a rollup version with a different data-publication design (calldata or a hash-committed scheme) and circuits, which portals and users move to; post-quantum data availability in the Ethereum protocol would also replace the opening
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/aztec-blob-kzg/notes.md
  - evidence/aztec-blob-kzg/aztec-system.json
sources:
- by: ai-assisted
  who: Review00 (verified source of rollup versions 0, 2 and 3; Registry, GSE and portal reads; Xatu activity); split from the committee-attestation classification, which noted the blob opening
  ref: evidence/aztec-blob-kzg/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [aztec-committee-attestations, aztec-honk-verifier]
---

## Summary

Every Aztec checkpoint is published in EIP-4844 blobs, and each epoch proof is tied to those blobs by a KZG opening
checked with the point-evaluation precompile (`0x0a`). A quantum attacker who recovers the KZG ceremony trapdoor can
open a blob commitment to any value, so an epoch can be proven although the published blobs do not contain the
transactions: the blob publisher withholds the data and anyone with the trapdoor proves the epoch. The SNARK still
checks the state transition, so funds are locked, not taken: L2 funds that need the withheld state to be withdrawn,
bounded on L1 by the live versions' portals (about USD 81k on 2026-11-17). No deployed rollup version has a calldata
mode or a switch; a protocol change, or a new rollup version with a different data design, replaces it. Rated MEDIUM
(step 4: no fallback in the deployed rollups, but a governance vote can register a new rollup version that uses
calldata DA; step 5 does not lower it, USD 81k exposed).

## Mechanism

- `Rollup.propose` → `ProposeLib` → `BlobLib.validateBlobs(_blobsInput, checkBlob)` (v3 `ProposeLib.sol` line 205;
  `BlobLib.sol` lines 80–112): each KZG commitment's versioned hash must equal the transaction's `blobhash(i)`; the
  commitments are accumulated into `blobCommitmentsHash`. `checkBlob` is `true` (v3 `RollupCore.sol` line 214) and
  no function changes it.
- `submitEpochRootProof` → `EpochProofLib.verifyEpochRootProof` (v3 line 594) → `BlobLib.validateBatchedBlob`
  (lines 148–152): point evaluation of the batched commitment `C` at `z` equal to `y`, then the Honk proof with
  `blobCommitmentsHash`, `z` and `y` as public inputs. The opening is what makes the proven transaction effects the
  published ones. v2 (line 149) and version 0 (`BlobLib.sol` line 149, `EpochProofLib.sol` line 365) are the same.
- Who can use a forged opening: anyone can submit an epoch proof (no caller check); the blobs are published by whoever
  sends `propose` under the slot proposer's signature, or by the escape hatch's designated proposer.
- Pattern PQ-8. Details and line references: [`notes.md`](../evidence/aztec-blob-kzg/notes.md).

## Evidence

- CHECKED (verified source: Blockscout for v2 and v3, Sourcify for version 0, read 2026-11-17): the path above; the
  v3 build's `@aztec-blob-lib` remapping points at a wrapper that calls the core `BlobLib` on mainnet.
- CHECKED (`eth_call`, block 26,431,459): Registry `0x35b22e09…` canonical rollup `0xe37a2663…`; v2 and v3 have
  pending checkpoints beyond the proven ones (running); version 0 is halted (proven = pending block 139,350, no
  attesters) ([`aztec-system.json`](../evidence/aztec-blob-kzg/aztec-system.json)).
- CHECKED (Xatu call frames, blocks 26,208,000–26,423,999): portals using each version's Inbox and Outbox, holdings
  from Blockscout on 2026-11-17; rollup activity as in the table.
- CHECKED (precompile trace to March 2026): version 0 called the point-evaluation precompile (classification of
  `0x603bb2c0…` in [aztec-committee-attestations](aztec-committee-attestations.md)).
- INFERRED: honest validators and nodes keep the transaction data from the p2p network, so in practice the data may
  survive off L1; the contract does not guarantee it.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xe37a2663…` Rollup v3 (canonical) | no | $62.2k escrow | 2026-11-16 | 44,053 |
| `0x91ff8bbd…` Rollup v2 | no | $19.0k escrow | 2026-11-16 | 44,350 |
| `0x603bb2c0…` Rollup v0 (halted) | no | — | 2026-11-13 | 28 |

Escrow (2026-11-17, AZTEC at USD 0.010135): v3 portals USD 62.0k (OxidePortal `0xcb99c58f…` USD 44.7k, OxidePortal
`0x2ebfee28…` USD 16.8k, TokenPortals USD 0.5k) plus FeeJuicePortal `0x534361be…` USD 229; v2 portals USD 17.1k plus
FeeJuicePortal `0xaf73dd51…` USD 1.8k. These are the L1 balances backing L2 funds whose withdrawal needs the
withheld state; portals were found from 30-day activity only, so this is a lower bound. Validator stake and rewards
are not affected.

## Remediation

- Protocol: post-quantum data availability on Ethereum (blob commitments without the KZG ceremony) replaces the
  opening for every version.
- Without a protocol change: Aztec Governance `0x1102471eb3378fee427121c9efcea452e4b6b75e` would have to register a
  rollup version that publishes data differently (calldata or a hash-committed scheme, with new circuits), and
  portals and L2 users would move to it. No version today has such a mode, and the current ones cannot be switched.
- No user action helps beyond keeping funds on L1.

## History

- 2026-11-17 review (Review00): created at Main's request from the blob opening noted in
  aztec-committee-attestations (PQ-8 split out). Rated HIGH (step 4: KZG dependency with no fallback the admin can
  switch to; `checkBlob` fixed, no calldata mode); `impact` funds-locked because the SNARK still checks the state
  transition and a forged opening only lets the blob publisher withhold data; exposure USD 81k escrow, so step 5
  does not lower it.
- 2026-11-17 rubric correction: HIGH -> MEDIUM, step 4: the deployed rollups have no calldata mode, but Aztec Governance registers new rollup versions, which can use calldata DA (a governance vote plus a new deployment that portals and users move to); exposure USD 81k is above USD 50k, so step 5 does not lower it; `fix.layer` protocol -> new-deployment, `protocol_change` required -> helps.
