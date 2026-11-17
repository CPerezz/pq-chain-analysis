---
id: polyhedra-zkbridge-groth16
title: "Polyhedra zkBridge light clients on Ethereum: a quantum attacker who recovers the Groth16 setup trapdoor can import forged BSC, Polygon, Optimism/Arbitrum or Sei block headers and forge messages to the zkBridge endpoint and the LayerZero zkLightClient DVN"
project: polyhedra
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x8f34332dec0c624c3ccf3733d0998d5aee92800f"
  implementation: null
  name: OptimisticBlockVerifier1 (OptimisticBlockRouter blockVerifier[1])
  upgradeable: "no"
  admin: OptimisticBlockRouter proxy 0x7d09d6491df52f1511ec29ff2f0571854a440cb1 setBlockVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-29
  txs_30d: 0
- address: "0x00c8972ef8e2937af50f3d5ee115a5e2dfa2216c"
  implementation: null
  name: OptimisticBlockVerifier4 (OptimisticBlockRouter blockVerifier[4])
  upgradeable: "no"
  admin: OptimisticBlockRouter proxy 0x7d09d6491df52f1511ec29ff2f0571854a440cb1 setBlockVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-28
  txs_30d: 0
- address: "0xbf9720de605b7c3886bc151976a5140b1ae8a3e0"
  implementation: null
  name: BscVerifier1 (BscBlockUpdater blockVerifier[1])
  upgradeable: "no"
  admin: BscBlockUpdater proxy 0x11732663d735db99569bd9fd19dc853fbea48696 setVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-07-10
  txs_30d: 0
- address: "0x33cc71549afd56c22c9ed1cede1e7e105f0891ff"
  implementation: null
  name: PolygonNormal1Verifier (PolygonBlockUpdater blockVerifier[1])
  upgradeable: "no"
  admin: PolygonBlockUpdater proxy 0xcc069839654d10ebe29229a9f44bbb0a8056b28d setBlockVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-28
  txs_30d: 0
- address: "0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf"
  implementation: null
  name: SeiBlockVerifier (SeiBlockUpdater blockVerifier; no pairing call since 2025-10-31)
  upgradeable: "no"
  admin: SeiBlockUpdater proxy 0xa51c40a4157cf48dba69927bbfdc0f265e382fd4 setBlockVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-10-31
  txs_30d: 0
- address: "0x61780900dce0b4a3f8b52d8081cb0c77a0088cc8"
  implementation: null
  name: PolygonNormal2Verifier (PolygonBlockUpdater blockVerifier[2])
  upgradeable: "no"
  admin: PolygonBlockUpdater proxy 0xcc069839654d10ebe29229a9f44bbb0a8056b28d setBlockVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-04
  txs_30d: null
- address: "0xe14f90620c30f932ca05ccc95a68d34ca340ea2f"
  implementation: null
  name: PolygonSprint1Verifier (PolygonBlockUpdater validatorVerifier[1])
  upgradeable: "no"
  admin: PolygonBlockUpdater proxy 0xcc069839654d10ebe29229a9f44bbb0a8056b28d setValidatorVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-10-03
  txs_30d: null
- address: "0xb573d1fcd7f1a8528033d58998d931670a717e6d"
  implementation: null
  name: PolygonSprint2Verifier (PolygonBlockUpdater validatorVerifier[2])
  upgradeable: "no"
  admin: PolygonBlockUpdater proxy 0xcc069839654d10ebe29229a9f44bbb0a8056b28d setValidatorVerifier, owner Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-05-11
  txs_30d: null
- address: "0xcc381170112c2b831ad1be361ed385cf2e572b12"
  implementation: null
  name: BscVerifier1 (retired; no longer set in BscBlockUpdater)
  upgradeable: "no"
  admin: none; not referenced by the updaters read
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-07-04
  txs_30d: 0
- address: "0x6a9280663511928342ca8d809d8553ae437a0706"
  implementation: null
  name: BscVerifier1 (retired; no longer set in BscBlockUpdater)
  upgradeable: "no"
  admin: none; not referenced by the updaters read
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-29
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Polyhedra Safe 0xa926f089e07a9fd7a1a9438b1bb801963807a6d7 (3 of 5; owner of every updater, the ZKBridge endpoint, the LayerZero DVN and ProxyAdmin 0xe16d201ca134345601631d327a971a3741646b0d) points the updaters at post-quantum verifiers once Polyhedra has hash-based proof circuits and provers
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/polyhedra-zkbridge-groth16/classification.jsonl
  - evidence/polyhedra-zkbridge-groth16/onchain.json
  - evidence/polyhedra-zkbridge-groth16/activity.json
  - evidence/polyhedra-zkbridge-groth16/source-excerpts.md
  - evidence/polyhedra-zkbridge-groth16/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_1.jsonl,out_2.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (updater verifier slots, ZKBridge endpoint and ZkBridgeOracleV2 sources, owner reads)
  ref: evidence/polyhedra-zkbridge-groth16/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Polyhedra's zkBridge light clients on Ethereum import block headers of BSC, Polygon, Optimism/Arbitrum-type chains
and Sei only with a Groth16 proof checked by these BN254 verifiers. A quantum attacker who recovers a circuit's setup
trapdoor can prove a false header, then use a matching fake receipt to make the zkBridge endpoint deliver any message
(`zkReceive`) and the LayerZero V2 zkLightClient DVN attest any packet from that chain. The zkBridge token bridge that
receives those messages holds only about USD 320; the value of LayerZero apps that rely on this DVN was not measured.
All updaters, the endpoint and the DVN are owned by one Polyhedra 3-of-5 Safe that can repoint the verifiers. Rated
MEDIUM (step 4: fixed by a new verifier the owner points at, which needs new post-quantum circuits and provers).

## Mechanism

- Each verifier is a snarkjs/OKIMS-style Groth16 contract: `verifyProof(a, b, c, input)` computes the input
  commitment with `ecmul`/`ecadd` and checks `ecpairing` against a hard-coded verifying key
  ([`source-excerpts.md`](../evidence/polyhedra-zkbridge-groth16/source-excerpts.md)).
- Updaters call them on import: `OptimisticBlockRouter.importBlock` → `blockVerifier[blockSize].verifyProof`
  (line 665); `PolygonBlockUpdater` → `circuitVerifier.verifyProof` (lines 108, 136); likewise `BscBlockUpdater` and
  `SeiBlockUpdater`. A verified header's `(blockHash, receiptsRoot)` is then accepted by `checkBlock` /
  `checkBlockConfirmation`.
- Consumers: `ZKBridge.validateTransactionProof` (endpoint `0xa8a4547b…`, line 92) proves a receipt against
  `blockUpdaters[src].checkBlock` (line 104) and calls `zkReceive` on the destination app (line 121);
  `ZkBridgeOracleV2.verifyByTx` (DVN `0x8ddf05f9…`, line 192) uses `blockUpdater.checkBlockConfirmation` (line 223)
  to attest LayerZero packets.
- Pattern PQ-7.

## Evidence

- CHECKED (verified source, Sourcify/Blockscout): all ten verifiers are Groth16 BN254 verifiers; updater, endpoint
  and DVN sources as above ([`notes.md`](../evidence/polyhedra-zkbridge-groth16/notes.md)).
- CHECKED (`cast`, block ~26,431,606–26,431,710): verifier slots — router `blockVerifier(1)` = `0x8f34332d…`,
  `(4)` = `0x00c8972e…`; BscBlockUpdater `blockVerifier(1)` = `0xbf9720de…`; PolygonBlockUpdater
  `blockVerifier(1)` = `0x33cc7154…`, `blockVerifier(2)` = `0x61780900…`, `validatorVerifier(1)` = `0xe14f9062…`,
  `validatorVerifier(2)` = `0xb573d1fc…`; SeiBlockUpdater `blockVerifier()` = `0xe57d959a…`. `0xcc381170…` and
  `0x6a928066…` are in no slot read.
- CHECKED (Sourcify exact match, Blockscout): `0x61780900…` = `PolygonNormal2Verifier`, `0xe14f9062…` =
  `PolygonSprint1Verifier`, `0xb573d1fc…` = `PolygonSprint2Verifier` (`contracts/block/polygon/`, Groth16 with the
  BN254 `PRIME_Q`), all deployed at blocks 19,474,766–19,474,773 by `0xe343ce39…`, the same deployer as
  `PolygonNormal1Verifier` and the Sei verifier, and set in the Polyhedra-owned PolygonBlockUpdater: Polyhedra's.
- CHECKED: every updater proxy's EIP-1967 admin is ProxyAdmin `0xe16d201c…`, whose owner, like each updater's,
  the endpoint's and the DVN's `owner()`, is Safe `0xa926f089…` (3 of 5).
- CHECKED: endpoint `blockUpdaters(3)` = BscBlockUpdater, `(4)` = PolygonBlockUpdater, `(7)`/`(8)`/`(13)` =
  OptimisticBlockUpdaters on the router; DVN `blockUpdaters(eid)` for BSC, Polygon, Optimism, Arbitrum and Sei = the
  same updaters. DVN last `verifyByTx` 2026-10-24 (Blockscout).
- CHECKED (Xatu, any function): no verifier calls in 2026-10-16 to 2026-11-16; last updater imports 2026-06-28 to
  2026-07-10 by EOA `0x08cef23b…` ([`activity.json`](../evidence/polyhedra-zkbridge-groth16/activity.json)).
- CHECKED (precompile trace, remote): last pairing calls of the Sei and the two retired BSC verifiers 2025-10-31,
  2025-04-29 and 2025-07-04; of `0x61780900…` 2026-03-04 (10 calls in total), `0xe14f9062…` 2025-10-03 (12) and
  `0xb573d1fc…` 2025-05-11 (1). These three are not in the Xatu activity scan, so their 30-day counts are unmeasured.
- CHECKED (Blockscout token balances, 2026-11-17): zkBridge `Bridge` proxy `0x89a56ff4…` holds USD 314 of priced
  tokens and 0.005 ETH.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x8f34332d…` OptimisticBlockVerifier1 | no (repointable) | see below | 2026-06-29 | 0 |
| `0x00c8972e…` OptimisticBlockVerifier4 | no (repointable) | see below | 2026-06-28 | 0 |
| `0xbf9720de…` BscVerifier1 | no (repointable) | see below | 2026-07-10 | 0 |
| `0x33cc7154…` PolygonNormal1Verifier | no (repointable) | see below | 2026-06-28 | 0 |
| `0xe57d959a…` SeiBlockVerifier | no (repointable) | see below | 2025-10-31 | 0 |
| `0x61780900…` PolygonNormal2Verifier | no (repointable) | see below | 2026-03-04 | not measured |
| `0xe14f9062…` PolygonSprint1Verifier (validator-set updates) | no (repointable) | see below | 2025-10-03 | not measured |
| `0xb573d1fc…` PolygonSprint2Verifier (validator-set updates) | no (repointable) | see below | 2025-05-11 | not measured |
| `0xcc381170…` BscVerifier1 (retired) | no | none | 2025-07-04 | 0 |
| `0x6a928066…` BscVerifier1 (retired) | no | none | 2025-04-29 | 0 |

Escrow: the zkBridge token `Bridge` `0x89a56ff41a4be1360f780c5abfba8fd7eced2c7a`, the endpoint's only receiving app in
its recent logs, holds about USD 320. The larger consumer is the LayerZero V2 zkLightClient DVN
`0x8ddf05f9a5c488b4973897e278b58895bf87cb24`: any LayerZero app on Ethereum whose required DVNs this DVN alone
satisfies can be sent forged packets from these source chains. That value was not measured, so `value_usd` stays
null and the value step lowers nothing. The two Polygon validator-set verifiers matter as much as the block
verifiers: INFERRED, a forged validator-set update installs a validator set of the attacker's own keys, after which
their fake Polygon headers prove with honest proofs.

## Remediation

- Polyhedra must build post-quantum light-client proofs (hash-based STARK/FRI or similar, without a pairing setup)
  and deploy matching verifiers; Safe `0xa926f089e07a9fd7a1a9438b1bb801963807a6d7` then calls `setBlockVerifier` /
  `setVerifier` on each updater (or upgrades the updaters through ProxyAdmin `0xe16d201c…`).
- The proved statements also rest on pre-quantum signatures of the source chains (BSC and Polygon validator
  signatures), so the circuits need source chains with post-quantum consensus keys as well.
- LayerZero apps can drop the zkLightClient DVN from their required set or require additional DVNs.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. Status candidate -> confirmed, evidence bytecode -> source-read
  (all seven verifiers have verified source). Mapped each verifier to its updater slot; two BSC verifiers are retired;
  consumers are the ZKBridge endpoint and the LayerZero zkLightClient DVN, all owned by Safe `0xa926f089…`. Token
  bridge escrow USD ~320; DVN-secured value not measured.
- 2026-11-17 review (Review18, follow-up): added PolygonBlockUpdater's `blockVerifier(2)` `0x61780900…` and
  `validatorVerifier(1)`/`(2)` `0xe14f9062…`/`0xb573d1fc…` (verified Polyhedra Groth16 verifiers, same deployer).
  Re-rated MEDIUM -> MEDIUM, step 4: same owner Safe can repoint them; value still unmeasured.
