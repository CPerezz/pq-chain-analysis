---
id: paradex-blob-kzg
title: "Paradex core contract: a forged KZG blob opening lets an operator post state updates without their data, freezing the USD 25M in Paradex's L1 bridge; operators can already use calldata DA"
project: paradex
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0xf338cad020d506e8e3d9b4854986e0ece6c23640"
  implementation: "0x9961d34d3bae6914635c882e8fe382e14e0f172a"
  name: Paradex core (Starknet, StarkWare Proxy)
  upgradeable: "yes"
  admin: "StarkWare Proxy governors (no upgrade delay): Safes 0xff57a3bb6465501c993acf8f3b29125a862661c0 (3 of 5) and 0x0a64d3d7747549af6d65c225d56ac8f71e436b93 (3 of 6); operators 0x09d1ad25b369a0c48bdf4caab85afd08a3f07044, 0xc70ae19b5feaa5c19f576e621d2bad9771864fe2 (read at block 26431604)"
  value_usd: 25142677
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 6715
families: []
fix:
  layer: offchain
  who_acts: "Paradex operators 0x09d1ad25b369a0c48bdf4caab85afd08a3f07044, 0xc70ae19b5feaa5c19f576e621d2bad9771864fe2 switch to updateState (calldata DA); the proxy governors (Safes 0xff57a3bb6465501c993acf8f3b29125a862661c0, 0x0a64d3d7747549af6d65c225d56ac8f71e436b93) can upgrade the core to remove updateStateKzgDA"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/paradex-blob-kzg/classification.jsonl
  - evidence/paradex-blob-kzg/onchain.json
  - evidence/paradex-blob-kzg/activity.json
  - evidence/paradex-blob-kzg/source-excerpts.md
  - evidence/paradex-blob-kzg/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review01)
  ref: evidence/paradex-blob-kzg/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [starknet-blob-kzg]
---

## Summary

Paradex's L1 core contract (a Starknet-stack appchain core, same code as Starknet's) accepts each state update with
its data in EIP-4844 blobs, bound to the STARK-proven state diff by a KZG point-evaluation check (PQ-8). With the KZG
setup trapdoor, an operator can make a blob that does not contain the state diff pass that check, so the new state is
proven but its data is not published: users cannot rebuild their balances and the USD 25.1M in Paradex's L1 USDC
bridge (block 26,431,726) is frozen, not stolen, because the state transition is still checked by a hash-based STARK
proof. The same deployed contract offers `updateState` with calldata data availability, which the operators can use
instead. Rated LOW (step 4: a calldata-DA path the operators can already use in the deployed contract, and a forged
opening only withholds data).

## Mechanism

- `Starknet.updateStateKzgDA(programOutput, kzgProofs)` (implementation `0x9961d34d…`, `onlyOperator`) requires the
  output's `USE_KZG_DA` flag to be 1 and calls `verifyKzgProofs`: for each blob, `blobhash(i)` plus a staticcall to the
  point-evaluation precompile `0x0A` with the commitment and evaluation `y` taken from the STARK program output, and
  checks the precompile's fixed return value. Then `updateStateInternal` checks the SHARP fact registry (a STARK
  verifier) and applies the state.
- With the trapdoor, a KZG proof for any `(commitment, z, y)` verifies, so a blob whose content differs from the
  proven state diff passes (PQ-8). Only an address with `isOperator` can call the function, so the attacker must be
  or control an operator.
- Fallback: `Starknet.updateState(programOutput, onchainDataHash, onchainDataSize)` (same contract, `onlyOperator`)
  requires `USE_KZG_DA == 0` and binds the data through `OnchainDataFactTreeEncoder` (keccak, calldata DA). Which
  path is used is the operator's choice per update.
- The implementation is StarkWare's `Starknet.sol` (`identify()` = `StarkWare_Starknet_2026_11`); against Starknet's
  `0x73352c62…` it differs only in `setMinL1MsgFee` and the version string.

## Evidence

- CHECKED (verified source, Sourcify): implementation `0x9961d34d…`, `Starknet.sol` functions as quoted (the generated
  excerpt file is empty because it read the proxy).
- CHECKED (attribution): L2BEAT's Paradex page lists `0xF338cad0…` as the Paradex core contract and `0xE3cbE3A6…` as
  its USDC Bridge escrow, with the "Paradex Multisig" (3 of 6) and "Paradex Multisig 2" (3 of 5) matching the
  governor Safes below; Etherscan labels the core "Paradex: L1 Core Contract".
- CHECKED (block 26,431,604, [`escrow.json`](../evidence/paradex-blob-kzg/escrow.json)): `implementation()`,
  `getUpgradeActivationDelay()` = 0; governors `0xff57a3bb…` (Safe 3 of 5) and `0x0a64d3d7…` (Safe 3 of 6) from
  `LogNewGovernorAccepted`/`LogRemovedGovernor` logs, confirmed with `proxyIsGovernor` and `starknetIsGovernor`;
  operators `0x09d1ad25…` and `0xc70ae19b…` confirmed with `isOperator`.
- CHECKED (Blockscout, 50 latest transactions): all `updateStateKzgDA` from operator `0x09d1ad25…`.
- CHECKED (escrow, holdings at block 26,431,726): the L1 contracts that sent or received L1↔L2 messages through the
  core (`LogMessageToL2` since block 24,400,000, `LogMessageToL1` since 25,400,000; three 100k-block chunks failed):
  `StarknetTokenBridge` `0xe3cbe3a6…` USD 25.12M (USDC 20.7M, DIME 4.4M) and `0x45b79622…` 14.48 ETH.
- CHECKED (Xatu, [`activity.json`](../evidence/paradex-blob-kzg/activity.json)): 6,715 transactions in 2026-10-16 to
  2026-11-16; 13,342 KZG calls in the trace year (`curated_contracts.csv`, `txs_y1`).
- INFERRED: data withholding freezes rather than steals, because the core has no L1 forced-withdrawal path that reads
  blob data and the state transition stays STARK-proven.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xf338cad0…` Paradex core | yes (governors, no delay) | USD 25.1M (escrow, frozen) | 2026-11-16 | 6,715 |

Escrow: `0xe3cbe3a636ab6a754e9e41b12b09d09ce9e53db3` (USDC bridge) USD 25,116,437 and
`0x45b79622c095ab834b9c8dc71013ed13b39f1b8d` USD 26,240, USD 25,142,677 at block 26,431,726, a lower bound (bridges
with no message in the scanned windows are not counted). The core's own ETH is not the exposure.

## Remediation

- Now: the operators submit updates with `updateState` (calldata DA) instead of `updateStateKzgDA`; this is a
  sequencer configuration change, not a contract change. The cost is calldata gas.
- Later: the governors (Safes `0xff57a3bb…` 3 of 5 and `0x0a64d3d7…` 3 of 6) can upgrade the core to drop the KZG path,
  or to accept a post-quantum blob commitment once Ethereum has one.
- The operator keys are ECDSA EOAs; a CRQC that can forge an operator key can submit updates itself. That is a
  separate exposure and is not rated here.
- Users cannot do anything themselves beyond withdrawing to L1.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification (as part of `starknet-blob-kzg`), on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review01, in `starknet-blob-kzg`): HIGH -> MEDIUM, step 4 (revised rubric): `updateState` with calldata DA available to the operators; impact set to funds-locked; escrow measured (USD 25.1M); governors and operators read at block 26,431,604.
- 2026-11-17 rubric correction (in `starknet-blob-kzg`): MEDIUM -> LOW, step 4: operators can already post state with calldata DA in the deployed core, and a forged opening only withholds data; `protocol_change` helps -> not-needed.
- 2026-11-17 split (Review01): moved out of `starknet-blob-kzg` on Main's instruction after confirming Paradex from L2BEAT (core and USDC bridge addresses) and Etherscan's label; project starknet -> paradex; contract, its evidence (classification row, on-chain and activity entries, escrow reads) and the sources moved here. LOW unchanged.
