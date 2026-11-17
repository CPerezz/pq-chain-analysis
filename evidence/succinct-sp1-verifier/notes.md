# Review notes: succinct-sp1-verifier (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,737; callers from `trace_filter` on
https://eth.drpc.org over blocks 23,803,692–26,431,692 (about 365 days, run on the remote box, `callers-trace.json`).

## Verifiers and gateway routes

Each verifier is immutable (no proxy, no owner). `VERSION()` / `VERIFIER_HASH()` prefix and the route in the two
SP1VerifierGateways (owner Safe `0xcafef00d348adbd57c37d1b77e0619c6244c6878`, Safe 1.3.0, 2 of 3):

| Verifier | Version, type | Selector | Gateway `0x3b604117…` (Plonk) | Gateway `0x397a5f7f…` (Groth16) |
|---|---|---|---|---|
| `0x0459d576…` | v5.0.0 Plonk | `0xd4e8ecd2` | routed, not frozen | — |
| `0xe00a3cbf…` | v4.0.0-rc.3 Plonk | `0x1b34fe11` | routed, not frozen | — |
| `0x50acfbed…` | v5.0.0 Groth16 | `0xa4594c59` | — | routed, not frozen |
| `0xa27a057c…` | v4.0.0-rc.3 Groth16 | `0x11b6a09d` | — | routed, not frozen |
| `0x2bb76cb5…` | v5.0.0 Groth16 | `0xa4594c59` | — | (gateway routes this selector to `0x50acfbed…`) |
| `0x65b299f6…` | v5.0.0 Groth16 | `0xa4594c59` | — | (same) |

A gateway picks the verifier from the first 4 bytes of the proof, which the prover chooses; any consumer of a gateway can
be served a forged proof through any non-frozen route.

## Callers in the last 365 days (trace_filter)

- `0x0459d576…`: AgglayerGateway `0x046bb8bb…` (8,896 calls, last block 25,329,889), gateway `0x3b604117…` (9,786),
  OPSuccinctL2OutputOracle `0x31d543e7…` (2,671), Sp1LidoAccountingReportContract `0x135d3848…` (39).
- `0x50acfbed…`: gateway `0x397a5f7f…` (5,854, last 26,148,499), SP1VerifierGateway `0xf35a4088…` (2,598, last
  24,540,171), OnChainProposer `0xe13e7aa1…` (40, last 26,430,094).
- `0x2bb76cb5…`: SP1ICS07Tendermint `0x2e4600f0…` only (6,009, last 25,395,367).
- `0x65b299f6…`: SP1Beefy `0xa2703b8d…` only (312, last 24,493,090).
- `0xe00a3cbf…`, `0xa27a057c…`: no direct calls in the window.
- Gateway `0x3b604117…` callers: SP1Blobstream `0x7cf3876f…`, VerifiableApp `0xd330145c…`, SP1Vector `0x02993cdc…`,
  OPSuccinctL2OutputOracle `0x31d543e7…`, `0x73a0db39…`, `0x96337327…`, OPSuccinctL2OutputOracle `0xb4544083…`.
- Gateway `0x397a5f7f…` callers: SuccinctVApp `0x5ad5bc4b…`, SP1ICS07Tendermint `0x4bb8a05d…`, KalqiXSP1Verifier
  `0x12506fde…`, OPSuccinctL2OutputOracle `0x31d543e7…`, LiquidityOrchestrator `0xd1ac9305…`, OnChainProposer
  `0xe13e7aa1…`, AlignedProofAggregationService `0xd0696d3e…`, and about 20 smaller callers.

## AggLayer (largest consumer found)

- AgglayerGateway `0x046bb8bb…` (TransparentUpgradeableProxy → `0xd062b7f9…`, ProxyAdmin `0x0f99738b…` owned by
  PolygonZkEVMTimelock `0xef146245…`, min delay 259,200 s). `pessimisticVKeyRoutes(0x00000004)` and `(0x00000008)` →
  `0x0459d576…`, not frozen; `(0x0000000e)` → `0xc3c6ddda…`.
- Roles: `AL_ADD_PP_ROUTE_ROLE` and DEFAULT_ADMIN_ROLE held by the timelock `0xef146245…`; `AL_FREEZE_PP_ROUTE_ROLE`
  granted to Safe `0x242dae44…` (5 of 9) at block 22,717,971.
- Escrow: AgglayerBridge `0x2a3dd3eb832af982ec71669e178424b10dca2ede`, 3,521.97 ETH ($6.41M) + $119.43M tokens
  (Blockscout prices; HAUST alone $87.0M, LUMIA $12.9M, USDT $5.8M, USDC $4.0M), total $125.85M (`escrow.json`).
  [INFERENCE] a forged pessimistic proof is submitted through the rollup manager's trusted-aggregator path, so the
  attacker also needs that ECDSA key.

## Other consumer balances (Blockscout, 2026-11-17)

SuccinctVApp `0x5ad5bc4b…` $102,675 (PROVE); LiquidityOrchestrator `0xd1ac9305…` $14,109; VerifiableApp `0xd330145c…` $0.
OP Succinct portals, IBC Eureka escrows behind SP1ICS07Tendermint and SP1Beefy's bridge were not measured.

## Follow-up: SP1 v6.1.0 `0xc3c6dddac8829b233dc6536ec024775a57b0af2a` (block 26,431,750)

- Verified on Sourcify (`src/v6.1.0/SP1VerifierPlonk.sol`, `PlonkVerifier.sol`); created at block 24,878,258 through the
  CREATE2 deployer `0x4e59b448…`; no proxy, no owner.
- `VERSION()` = "v6.1.0"; `VERIFIER_HASH()` = `0x5a093a2f…`. Gateway `0x3b604117…` `routes(0x5a093a2f)` = (`0xc3c6ddda…`,
  not frozen); gateway `0x397a5f7f…` has no route for it. AgglayerGateway `pessimisticVKeyRoutes(0x0000000e)` =
  (`0xc3c6ddda…`, vkey `0x00d14f97…`, not frozen), added at block 25,322,110.
- `trace_filter` blocks 23,803,750–26,431,750 (`v6.1.0-trace.json`): callers Plonk gateway 19,555, AgglayerGateway 8,814,
  a few one-off callers; last block 26,431,706; 10,516 distinct transactions in the last 216,000 blocks.
