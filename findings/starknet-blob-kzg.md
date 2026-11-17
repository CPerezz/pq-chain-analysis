---
id: starknet-blob-kzg
title: "Starknet core contract: a forged KZG blob opening lets an operator post state updates without their data, freezing the USD 198M held by Starknet's L1 bridges; operators can switch to calldata DA"
project: starknet
status: confirmed
severity: LOW
patterns: [PQ-8]
primitives: [kzg]
trigger: trusted-setup
impact: funds-locked
alternative: alternative-exists
role: core
contracts:
- address: "0xc662c410c0ecf747543f5ba90660f6abebd9c8c4"
  implementation: "0x73352c6228ec1dcf737973db9822bb8e8a465c99"
  name: Starknet (StarkWare Proxy)
  upgradeable: "yes"
  admin: "StarkWare Proxy governors (no upgrade delay): Safe 0x15e8c684fd095d4796a0c0cf678554f4c1c7c361 (9 of 12) and DelayedExecutor 0xca112018feb729458b628aadc8f996f9decbca0c; operators 0x2c169dfe5fbba12957bdd0ba47d9cedbfe260ca7, 0xf6b0b3e8f57396cecfd788d60499db49ee6abc6b (read at block 26431604)"
  value_usd: 197614122
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 4775
families: []
fix:
  layer: offchain
  who_acts: "Starknet operators 0x2c169dfe5fbba12957bdd0ba47d9cedbfe260ca7, 0xf6b0b3e8f57396cecfd788d60499db49ee6abc6b switch to updateState (calldata DA); the proxy governors (Safe 0x15e8c684fd095d4796a0c0cf678554f4c1c7c361, DelayedExecutor 0xca112018feb729458b628aadc8f996f9decbca0c) can upgrade the core to remove updateStateKzgDA"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/starknet-blob-kzg/classification.jsonl
  - evidence/starknet-blob-kzg/onchain.json
  - evidence/starknet-blob-kzg/activity.json
  - evidence/starknet-blob-kzg/source-excerpts.md
  - evidence/starknet-blob-kzg/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review01)
  ref: evidence/starknet-blob-kzg/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [paradex-blob-kzg]
---

## Summary

Starknet's L1 core contract accepts each state update with its data in EIP-4844 blobs, bound to the STARK-proven
state diff by a KZG point-evaluation check (PQ-8). With the KZG setup trapdoor, an operator can make a blob that does
not contain the state diff pass that check, so the new state is proven but its data is not published: users cannot
rebuild their balances and the USD 198M in Starknet's L1 bridges (block 26,431,726) is frozen, not stolen, because
the state transition itself is still checked by a hash-based STARK proof. The same contract still offers
`updateState` with calldata data availability, so the operators can stop using blobs without a protocol change.
Rated LOW (step 4: a calldata-DA path the operators can already use in the deployed contract, and a forged opening
only withholds data; was MEDIUM). Paradex runs the same code and is in `paradex-blob-kzg`.

## Mechanism

- `Starknet.updateStateKzgDA(programOutput, kzgProofs)` (implementation `0x73352c62…`, `onlyOperator`) requires the
  output's `USE_KZG_DA` flag to be 1 and calls `verifyKzgProofs`: for each blob, `blobhash(i)` plus a staticcall to the
  point-evaluation precompile `0x0A` with the commitment and evaluation `y` taken from the STARK program output, and
  checks the precompile's fixed return value. Then `updateStateInternal` checks the SHARP fact registry
  (`IFactRegistry(verifier()).isValid(sharpFact)`, a STARK verifier) and applies the state.
- With the trapdoor, a KZG proof for any `(commitment, z, y)` verifies, so a blob whose content differs from the
  proven state diff passes (PQ-8). Only an address with `isOperator` can call the function, so the attacker must be
  or control an operator.
- Fallback: `Starknet.updateState(programOutput, onchainDataHash, onchainDataSize)` (same contract, `onlyOperator`)
  requires `USE_KZG_DA == 0` and binds the data through `OnchainDataFactTreeEncoder` (keccak, calldata DA). Which
  path is used is the operator's (sequencer's) choice per update; both are live in the deployed implementation.

## Evidence

- CHECKED (verified source, Sourcify): implementation `0x73352c62…`, `Starknet.sol` functions as quoted (the generated
  excerpt file is empty because it read the proxy, not the implementation).
- CHECKED (block 26,431,604): `implementation()`, `getUpgradeActivationDelay()` = 0; governors found
  from `LogNewGovernorAccepted`/`LogRemovedGovernor` logs and confirmed with `proxyIsGovernor` and
  `starknetIsGovernor`; operators from `LogOperatorAdded`/`LogOperatorRemoved` confirmed with `isOperator`
  ([`escrow.json`](../evidence/starknet-blob-kzg/escrow.json)).
- CHECKED (block 26,431,604): governor Safes' thresholds as in the header; `0xca112018…` is a verified StarkWare
  `DelayedExecutor`.
- CHECKED (Blockscout, 50 latest transactions): all `updateStateKzgDA`, from operator `0x2c169dfe…`.
- CHECKED (escrow, holdings at block 26,431,726): L1 contracts that sent or received L1↔L2 messages through the core
  (`LogMessageToL2` since block 24,400,000, `LogMessageToL1` since 25,400,000), ETH plus Blockscout-priced tokens.
- CHECKED (Xatu, [`activity.json`](../evidence/starknet-blob-kzg/activity.json)): 4,775 transactions in 2026-10-16 to
  2026-11-16; 14,957 KZG calls in the trace year (`curated_contracts.csv`, `txs_y1`).
- INFERRED: data withholding freezes rather than steals, because Starknet has no L1 forced-withdrawal path that reads
  blob data and the state transition stays STARK-proven.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xc662c410…` Starknet | yes (governors, no delay) | USD 197.6M (escrow, frozen) | 2026-11-15 | 4,775 |

Starknet escrow (43 L1 endpoints with code; largest): STRK bridge `0xce5485cfb26914c5dce00b9baf0580364dafc7a4`
USD 149.3M; ETH bridge `0xae0ee0a63a2ce6baeeffe56e7714fb4efe48d419` 16,956 ETH (USD 30.7M); multi-token bridge
`0xf5b6ee2caeb6769659f6c091d209dfdcaf3f69eb` USD 6.1M; USDC `0xf6080d9fbeebcd44d89affbfd42f098cbff92816` USD 4.2M;
USDT `0xbb3400f107804dfb482565ff1ec8d8ae66747605` USD 2.6M; tBTC, wstETH and smaller bridges the rest. Bridges with no
message in the scanned windows are not counted, so the figure is a lower bound. The core's own ETH (0.03 ETH) is not
the exposure.

## Remediation

- Now: the operators submit updates with `updateState` (calldata DA) instead of `updateStateKzgDA`; this needs a
  sequencer/OS configuration change, not a contract change. The cost is calldata gas.
- Later: the governors (Safe `0x15e8c684…` 9 of 12 and DelayedExecutor `0xca112018…`) can upgrade the core to drop
  the KZG path, or to accept a post-quantum blob commitment once Ethereum has one.
- The operator keys are ECDSA EOAs; a CRQC that can forge an operator key can submit updates itself. That is a
  separate exposure and is not rated here.
- Users cannot do anything themselves beyond withdrawing to L1.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: depends on the KZG precompile; only a protocol change replaces it).
- 2026-11-17 review (Review01): HIGH -> MEDIUM, step 4 (revised rubric): both cores keep `updateState` with calldata DA, which the operators can switch to without a protocol change; impact set to funds-locked (only operators submit openings, state stays STARK-proven); escrow measured (USD 197.6M and 25.1M); governors and operators read at block 26,431,604; second core attributed to Paradex (inferred).
- 2026-11-17 rubric correction: MEDIUM -> LOW, step 4: operators can already post state with calldata DA through `updateState` in the same deployed core contracts, and a forged opening only withholds data (funds-locked); `protocol_change` helps -> not-needed.
- 2026-11-17 split (Review01): Paradex's core `0xf338cad0…` (confirmed from L2BEAT and Etherscan) moved to `paradex-blob-kzg` on Main's instruction with its evidence (classification row, on-chain and activity entries, escrow reads); this finding now covers Starknet only. LOW unchanged.
