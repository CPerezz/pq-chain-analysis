# Review notes: unidentified-d941fb73-snark-verifier (2026-11-17, Review14)

## Consumer: a standalone Polygon CDK stack, not Polygon's shared RollupManager

Deployer `0xf91b53b5588c09442cfaaf8f921d8321b7d4649e` (EOA, funded 2025-02-13 by `0xdd114377c59d115d4e1d7d2ab80f0269025a137a`,
which also created the timelock below). Its 14 transactions (Blockscout), all 2025-02-13/14:

| Block | Action |
|---|---|
| 21,836,468 / 21,836,477 | `schedule` / `execute` on PolygonZkEVMTimelock `0x3dedc8fabbd2a440cbce479ea3c2458f4758f62e` |
| 21,836,484 | creates FflonkVerifier_12 `0xd941fb73…` |
| 21,836,485 | creates `0x3894f976728b57a6843e34160437c08aa9fcdf42` (consensus implementation) |
| 21,836,486 | `addNewRollupType` on RollupManager proxy `0x879f5504acdaa8529618be136b3672be583ebb93` |
| 21,836,487 | `createNewRollup` on the same RollupManager |
| 21,836,488 / 489 | creates `0x796dedb5…`, `0xc8988276…` (data committee) |
| 21,836,490 / 495 / 515 | `setDataAvailabilityProtocol`, `setTrustedSequencerURL` on rollup `0x91d3af7a…`, `setupCommittee` on `0xc8988276…` |
| 21,836,525 | `bridgeAsset` (amount 0, destination network 7) on bridge proxy `0x0a3014e1d323517e3895f4db75757f2c7781d0e6` |

## Reads (eth.drpc.org, block 26,431,595)

- RollupManager `0x879f…bb93`: `rollupCount()` = 1, `rollupTypeCount()` = 1; `rollupTypeMap(1)` = consensus
  `0x3894…df42`, verifier `0xd941fb73…`, forkID 12; `rollupIDToRollupData(1)` = rollup `0x91d3af7a…f0343`, chainID
  762419583, verifier `0xd941fb73…`, forkID 12, lastBatchSequenced 1278, lastVerifiedBatch 1278.
- RollupManager and bridge EIP-1967 admin: ProxyAdmin `0xf1f78417795565b7d710c7f3f8a203f586d5e12f`, `owner()` =
  PolygonZkEVMTimelock `0x3dedc8fa…f62e`; timelock `getMinDelay()` = 60; `hasRole(PROPOSER_ROLE, 0xf91b53b5…)` = true.
- RollupManager roles: timelock holds ADD_ROLLUP_TYPE_ROLE and UPDATE_ROLLUP_ROLE; the deployer EOA holds
  ADD_ROLLUP_TYPE_ROLE; neither holds TRUSTED_AGGREGATOR_ROLE.
- Polygon's shared AgglayerManager `0x5132…7ab2` does not list `0xd941fb73…` in any of its 14 rollup types
  (`evidence/polygon-fflonk-verifier/escrow.json`).

## Holdings (Blockscout, 2026-11-17)

Bridge `0x0a3014e1…` : 0 ETH; 9.499 AIRAS (`0x0624069497f830bea84bd7ad410b878270130035`, no price); RollupManager and
rollup contract: nothing.

## Identity

Chain ID 762419583 is not in chainid.network's list. The only asset in the bridge is the AIRAS token, and L2BEAT
lists an archived project "AIRAS" (search result for l2beat.com/scaling/projects/airas; the page itself returned
404 when fetched). No direct link from the AIRAS token creator `0xa038df4f…` to the deployer was found. Not
attributed.

## Trace

`data/agg/alltime_caller.parquet`: `0xd941fb73…` ecpairing 429 calls, blocks 21,836,729–22,217,151 (last 2025-04-07);
none since in `activity.json`.
