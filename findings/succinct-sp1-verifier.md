---
id: succinct-sp1-verifier
title: "Succinct SP1: a quantum attacker with a BN254 setup trapdoor can forge SP1 proofs accepted by six immutable verifiers and the SP1 gateways that route to them, releasing funds in consumers such as Polygon's AggLayer bridge ($126M)"
project: succinct
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x0459d576a6223feea177fb3df53c9c77bf84c459"
  implementation: null
  name: SP1Verifier (Plonk v5.0.0)
  upgradeable: "no"
  admin: "none (immutable); routed by SP1VerifierGateway 0x3b6041173b80e77f038f3f2c0f9744f04837185e (owner Safe 0xcafef00d348adbd57c37d1b77e0619c6244c6878, 2 of 3) and by AgglayerGateway 0x046bb8bb98db4cecbb2929542686b74b516274b3 routes 0x00000004 and 0x00000008; read at block 26,431,737"
  value_usd: 125849129
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-07-17
  txs_30d: 0
- address: "0x50acfbedecf4cbe350e1a86fc6f03a821772f1e5"
  implementation: null
  name: SP1Verifier (Groth16 v5.0.0)
  upgradeable: "no"
  admin: "none (immutable); routed by SP1VerifierGateway 0x397a5f7f3dbd538f23de225b51f532c34448da9b (owner Safe 0xcafef00d348adbd57c37d1b77e0619c6244c6878, 2 of 3), selector 0xa4594c59; read at block 26,431,737"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 31
- address: "0x2bb76cb5eab856ffb548320509266c5bfed46f82"
  implementation: null
  name: SP1Verifier (Groth16 v5.0.0, pinned by SP1ICS07Tendermint 0x2e4600f0)
  upgradeable: "no"
  admin: "none (immutable); not routed by a gateway; consumer SP1ICS07Tendermint 0x2e4600f0312d791251821d5b6195c0d8578fa25d"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-06-25
  txs_30d: 0
- address: "0xe00a3cbfc45241b33c0a44c78e26168cbc55ec63"
  implementation: null
  name: SP1Verifier (Plonk v4.0.0-rc.3)
  upgradeable: "no"
  admin: "none (immutable); still routed by SP1VerifierGateway 0x3b6041173b80e77f038f3f2c0f9744f04837185e, selector 0x1b34fe11, not frozen"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-06-17
  txs_30d: 0
- address: "0xa27a057cab1a4798c6242f6ee5b2416b7cd45e5d"
  implementation: null
  name: SP1Verifier (Groth16 v4.0.0-rc.3)
  upgradeable: "no"
  admin: "none (immutable); still routed by SP1VerifierGateway 0x397a5f7f3dbd538f23de225b51f532c34448da9b, selector 0x11b6a09d, not frozen"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-06-23
  txs_30d: 0
- address: "0x65b299f6d365f34a04b67f602b89f6fab094a012"
  implementation: null
  name: SP1Verifier (Groth16 v5.0.0, pinned by SP1Beefy 0xa2703b8d)
  upgradeable: "no"
  admin: "none (immutable); not routed by a gateway; consumer SP1Beefy 0xa2703b8dd14f50d17f2517327797bce292d00e1e"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-02-19
  txs_30d: 0
- address: "0xc3c6dddac8829b233dc6536ec024775a57b0af2a"
  implementation: null
  name: SP1Verifier (Plonk v6.1.0)
  upgradeable: "no"
  admin: "none (immutable); routed by SP1VerifierGateway 0x3b6041173b80e77f038f3f2c0f9744f04837185e (owner Safe 0xcafef00d348adbd57c37d1b77e0619c6244c6878, 2 of 3), selector 0x5a093a2f, and by AgglayerGateway 0x046bb8bb98db4cecbb2929542686b74b516274b3 route 0x0000000e, neither frozen; read at block 26,431,750"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: 10516
families: []
fix:
  layer: onchain-config
  who_acts: "Succinct (gateway owner Safe 0xcafef00d348adbd57c37d1b77e0619c6244c6878, 2 of 3) adds a hash-based verifier route and freezes the BN254 routes; Polygon (AgglayerGateway 0x046bb8bb98db4cecbb2929542686b74b516274b3: PolygonZkEVMTimelock 0xef1462451c30ea7ad8555386226059fe837ca4ef adds routes, Safe 0x242dae44f5d8fb54b198d03a94da45b5a4413e21 freezes) does the same; consumers pinned to a verifier (SP1ICS07Tendermint 0x2e4600f0…, SP1Beefy 0xa2703b8d…, OnChainProposer 0xe13e7aa1…, Lido 0x135d3848…) repoint through their own admins"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/succinct-sp1-verifier/classification.jsonl
  - evidence/succinct-sp1-verifier/onchain.json
  - evidence/succinct-sp1-verifier/activity.json
  - evidence/succinct-sp1-verifier/source-excerpts.md
  - evidence/succinct-sp1-verifier/notes.md
  - evidence/succinct-sp1-verifier/callers-trace.json
  - evidence/succinct-sp1-verifier/escrow.json
  - evidence/succinct-sp1-verifier/v6.1.0-trace.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_3.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/succinct-sp1-verifier/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

SP1's on-chain verifiers check a Groth16 or PLONK proof on BN254 that wraps the SP1 STARK (PQ-7); with the setup
trapdoor a proof of any program output verifies. These seven verifiers are immutable, but consumers reach them through
routes: Succinct's two SP1VerifierGateways (owner Safe, 2 of 3), where the proof's first four bytes pick the verifier,
and Polygon's AgglayerGateway, which routes pessimistic proofs to the v5 and v6.1.0 Plonk verifiers. The live one is
v6.1.0 `0xc3c6ddda…` (about 10,500 transactions in the last 30 days, through the Plonk gateway for Taiko and others, and
through AgglayerGateway). The largest escrow found behind them is Polygon's AggLayer bridge, $125.8M on 2026-11-17.
Rated MEDIUM (step 4): each gateway admin can add a hash-based verifier route and freeze the BN254 ones, and pinned
consumers can repoint, without a protocol change.

## Mechanism

- `SP1Verifier.verifyProof(programVKey, publicValues, proofBytes)` checks that the proof starts with `VERIFIER_HASH`'s
  first 4 bytes and calls the gnark Groth16Verifier or PlonkVerifier, which end in the BN254 pairing precompile
  ([`source-excerpts.md`](../evidence/succinct-sp1-verifier/source-excerpts.md)).
- `SP1VerifierGateway.verifyProof` reads the first 4 bytes of the proof, looks up `routes(selector)` and forwards if the
  route is not frozen. The prover chooses the selector, so any consumer of a gateway can be served a forged proof through
  any open route, including the v4.0.0-rc.3 verifiers `0xe00a3cbf…` and `0xa27a057c…`, which are still routed though
  nobody used them in the past year.
- AgglayerGateway `verifyPessimisticProof` uses `pessimisticVKeyRoutes`; routes `0x00000004` and `0x00000008` point to
  `0x0459d576…`, route `0x0000000e` to `0xc3c6ddda…`; none is frozen.
- v6.1.0 `0xc3c6ddda…` (`src/v6.1.0/SP1VerifierPlonk.sol`, verified on Sourcify, `VERIFIER_HASH` prefix `0x5a093a2f`)
  is routed by the Plonk gateway `0x3b604117…`. Taiko's SP1 leg reaches it through that gateway
  (`taiko-zk-verifiers`).
- `0x2bb76cb5…` and `0x65b299f6…` are separate deployments of the v5 Groth16 verifier pinned by one consumer each
  (SP1ICS07Tendermint `0x2e4600f0…`, SP1Beefy `0xa2703b8d…`).

## Evidence

- CHECKED (verified source, Sourcify): SP1VerifierGroth16 / SP1VerifierPlonk v5.0.0 and v4.0.0-rc.3, SP1VerifierPlonk
  v6.1.0.
- CHECKED (on-chain read, block 26,431,737): `VERSION()`, `VERIFIER_HASH()`, both gateways' `routes()` and owner Safe
  `0xcafef00d…` (2 of 3); AgglayerGateway routes, ProxyAdmin owner (PolygonZkEVMTimelock, 3-day delay) and route-freeze
  role holder Safe `0x242dae44…` (5 of 9) ([`notes.md`](../evidence/succinct-sp1-verifier/notes.md)).
- CHECKED (`trace_filter`, blocks 23,803,692–26,431,692): callers of each verifier and gateway
  ([`callers-trace.json`](../evidence/succinct-sp1-verifier/callers-trace.json)).
- CHECKED (`trace_filter`, blocks 23,803,750–26,431,750): `0xc3c6ddda…` called by the Plonk gateway (19,555 calls) and
  AgglayerGateway (8,814), last block 26,431,706; 10,516 transactions in the last 216,000 blocks (about 30 days; this
  count comes from the trace, not Xatu) ([`v6.1.0-trace.json`](../evidence/succinct-sp1-verifier/v6.1.0-trace.json)).
- CHECKED (Blockscout, 2026-11-17): AgglayerBridge `0x2a3dd3eb…` holds 3,521.97 ETH and $119.4M in tokens; SuccinctVApp
  $102.7k; LiquidityOrchestrator $14.1k ([`escrow.json`](../evidence/succinct-sp1-verifier/escrow.json)).
- CHECKED (Xatu, any function): last activity and 30-day counts in the table
  ([`activity.json`](../evidence/succinct-sp1-verifier/activity.json)).
- INFERRED: that a forged AggLayer pessimistic proof also needs the rollup manager's trusted-aggregator key (ECDSA,
  recoverable) and can then release bridge funds.

## Impact and exposure

| Contract | Upgradeable | Reached by | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0459d576…` Plonk v5.0.0 | no | Plonk gateway; AgglayerGateway; OP Succinct oracle `0x31d543e7…`; Lido `0x135d3848…` | 2026-07-17 | 0 |
| `0x50acfbed…` Groth16 v5.0.0 | no | Groth16 gateway; gateway `0xf35a4088…`; OnChainProposer `0xe13e7aa1…` | 2026-11-15 | 31 |
| `0x2bb76cb5…` Groth16 v5.0.0 | no | SP1ICS07Tendermint `0x2e4600f0…` | 2026-06-25 | 0 |
| `0xe00a3cbf…` Plonk v4.0.0-rc.3 | no | Plonk gateway (open route) | 2025-06-17 | 0 |
| `0xa27a057c…` Groth16 v4.0.0-rc.3 | no | Groth16 gateway (open route) | 2025-06-23 | 0 |
| `0x65b299f6…` Groth16 v5.0.0 | no | SP1Beefy `0xa2703b8d…` | 2026-02-19 | 0 |
| `0xc3c6ddda…` Plonk v6.1.0 | no | Plonk gateway (Taiko and others); AgglayerGateway route `0x0000000e` | 2026-11-17 | 10,516 |

- Escrow on `0x0459d576…`: AgglayerBridge `0x2a3dd3eb…`, $125.8M (2026-11-17, Blockscout prices; one token, HAUST,
  is $87.0M of it). `0xc3c6ddda…` reaches the same bridge through route `0x0000000e`; it is not counted twice.
- Taiko's bridge and vaults ($9.95M, counted in `taiko-zk-verifiers`) are reached through `0xc3c6ddda…` together with a
  RISC Zero proof.
- Gateway consumers include SP1Blobstream, SP1Vector, OP Succinct L2 output oracles, SuccinctVApp ($102.7k), IBC Eureka
  light clients, Aligned and others (about 30 callers); their escrows (OP Succinct portals, IBC escrows) were not
  measured, so the total exposure is higher than the AggLayer figure.
- Yearly pre-quantum counts from the census (`txs_y1`): 21,863 / 14,809 / 6,984 / 3,038 / 538 / 312; `0xc3c6ddda…` is
  not in the census (created at block 24,878,258, after the March 2026 precompile trace).

## Remediation

- Succinct: deploy a verifier for SP1's STARK without the BN254 wrap (FRI/WHIR), add it as a route in both gateways and
  freeze the BN254 routes (`freezeRoute`), owner Safe `0xcafef00d…` (2 of 3). Gateway consumers then need no change.
- Polygon: add a pessimistic route to a hash-based verifier (PolygonZkEVMTimelock `0xef146245…`, 3-day delay) and freeze
  routes `0x00000004`, `0x00000008`, `0x0000000e` (Safe `0x242dae44…`).
- Pinned consumers (SP1ICS07Tendermint `0x2e4600f0…`, SP1Beefy `0xa2703b8d…`, OnChainProposer `0xe13e7aa1…`, Lido
  `0x135d3848…`, OP Succinct oracles) repoint through their own admins.
- No protocol change is needed; the cost is higher verification gas.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM unchanged (step 4: gateway owners re-route and pinned consumers repoint; several known parties). Escrow measured: AgglayerBridge 0x2a3dd3eb… $125.8M via AgglayerGateway routes to 0x0459d576…. Routes and owners read; the two v4.0.0-rc.3 verifiers are idle but still routed, so step 1 does not apply.
- 2026-11-17 follow-up (Review11): added the live SP1 v6.1.0 Plonk verifier `0xc3c6ddda…` (gateway selector 0x5a093a2f and AgglayerGateway route 0x0000000e, neither frozen; 10,516 transactions in about 30 days by trace). MEDIUM unchanged (step 4: same route owners can freeze it).
