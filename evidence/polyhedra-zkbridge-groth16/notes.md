# Review notes: polyhedra-zkbridge-groth16 (2026-11-17, Review18)

All reads with `cast` against https://ethereum-rpc.publicnode.com at block ~26,431,606–26,431,710 unless noted.

## Consumers of the verifiers

Light-client updaters (all `OptimizedTransparentUpgradeableProxy`, EIP-1967 admin slot = ProxyAdmin
`0xe16d201ca134345601631d327a971a3741646b0d`, whose `owner()` = Safe `0xa926f089e07a9fd7a1a9438b1bb801963807a6d7`,
threshold 3 of 5; each proxy's `owner()` = the same Safe):

| Updater | Implementation (verified name) | Verifier slots read |
|---|---|---|
| `0x7d09d6491df52f1511ec29ff2f0571854a440cb1` | `OptimisticBlockRouter` `0x9b72c611…` | `blockVerifier(1)` = `0x8f34332d…`, `blockVerifier(4)` = `0x00c8972e…` |
| `0x11732663d735db99569bd9fd19dc853fbea48696` | `BscBlockUpdater` `0xbe0b942d…` | `blockVerifier(1)` = `0xbf9720de…` (0, 2, 3 empty) |
| `0xcc069839654d10ebe29229a9f44bbb0a8056b28d` | `PolygonBlockUpdater` `0x75d32e80…` | `blockVerifier(1)` = `0x33cc7154…`, `blockVerifier(2)` = `0x61780900…`, `validatorVerifier(1)` = `0xe14f9062…`, `validatorVerifier(2)` = `0xb573d1fc…` |
| `0xa51c40a4157cf48dba69927bbfdc0f265e382fd4` | `SeiBlockUpdater` `0x8a04e421…` | `blockVerifier()` = `0xe57d959a…` |

OptimisticBlockUpdaters `0x9d5a7f0c…` (chain 7), `0x29aea169…` (8), `0x5e359af0…` (13) have `blockRouter()` =
`0x7d09d649…`.

`0x6a928066…` and `0xcc381170…` (BscVerifier1) are not in any verifier slot read above: retired. All seven verifiers
were created by Polyhedra deployers (`0x063f9c3f…` for the Optimistic ones, which also created the updater proxies;
`0xe343ce39…` for Sei, Polygon and the two old BSC ones; `0x7ce36f20…` for `0xbf9720de…`, now set by the Polyhedra
Safe), so the attribution of `0x6a928066…` to Polyhedra holds.

Last updater transactions in the trace window (Xatu): `importBlock` (`0x36fbafad`) on `0x7d09d649…` (blocks
25,417,411 and 25,424,918) and `0x11732663…` (25,498,486), `0xf6564655` on `0xcc069839…` (25,417,422), all sent by
EOA `0x08cef23bf83030d105dd51b5a4553d40094a05d3`.

## What the updaters secure

1. zkBridge messaging endpoint `ZKBridge` proxy `0xa8a4547be2ece6dde2dd91b4a5adfe4a043b21c7` (impl `0x6eab43ce…`,
   Sourcify exact; admin ProxyAdmin `0xe16d201c…`; `owner()` Safe `0xa926f089…`). `validateTransactionProof`
   (ZKBridge.sol line 92) checks the receipt MPT proof against `blockUpdaters[_srcChainId].checkBlock(...)` (line 104)
   and calls `zkReceive` on the destination app (line 121). `blockUpdaters(3)` = `0x11732663…`, `(4)` =
   `0xcc069839…`, `(7)`/`(8)`/`(13)` = OptimisticBlockUpdaters, plus 12 other chains.
   Receiving app seen in its last 50 logs: `Bridge` proxy `0x89a56ff41a4be1360f780c5abfba8fd7eced2c7a` (impl
   `0xb74fc039…`), holding USD 314 of priced tokens (ZKJ 255, USDT 59; Blockscout token balances 2026-11-17) and
   0.00508 ETH.
2. LayerZero V2 zkLightClient DVN `ZkBridgeOracleV2` proxy `0x8ddf05f9a5c488b4973897e278b58895bf87cb24` (address from
   docs.zkbridge.com; impl `0xdff54e8d…`, Sourcify exact; `owner()` Safe `0xa926f089…`). `verifyByTx` (line 192)
   checks `blockUpdater.checkBlockConfirmation(...)` (line 223). `blockUpdaters(eid)`: 30102 (BSC) = `0x11732663…`,
   30109 (Polygon) = `0xcc069839…`, 30111/30110 (Optimism/Arbitrum) = OptimisticBlockUpdaters, 30280 (Sei) =
   `0xa51c40a4…`. Last `verifyByTx` transaction 2026-10-24 (Blockscout). The value of LayerZero apps that require this
   DVN was not measured; a forged DVN attestation alone releases funds only for apps whose required DVN set it
   satisfies on its own.

## Precompile use (data/agg/alltime_caller.parquet, remote)

Last BN254 pairing call: `0xe57d959a…` block 23,696,472; `0x6a928066…` 22,372,386; `0xcc381170…` 22,842,661;
`0x33cc7154…` 24,525,633. Polygon siblings added in the follow-up (Sourcify names `PolygonNormal2Verifier`,
`PolygonSprint1Verifier`, `PolygonSprint2Verifier`; deployer `0xe343ce39…`): `0x61780900…` (10 pairings, last
24,583,192), `0xe14f9062…` (12, last 23,495,900), `0xb573d1fc…` (1, block 22,457,308).
