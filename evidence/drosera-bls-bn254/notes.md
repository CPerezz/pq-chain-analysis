# Review reads (Review15, 2026-11-17)

## Identity (Blockscout)

| Address | Name / role | Creator |
|---|---|---|
| `0x01c344b8406c3237a6b9dbd06ef2832142866d87` | unverified router | `0x4d1c87ec4fc08391e8b7a09bc988e87ca54bec0b` (EOA, owner of Safe `0xf5cd…8935`) |
| `0x1975be6dad2e829b1cd6c9d618ddd3ec405c1712` | "Staked Drosera", `symbol()` sDRO, `totalSupply()` 1e9 | `0x4d1c87ec…` |
| `0xd569cb695a30f7dc593190c69e04cc4748e5def0` | implementation for selector `0x96051d56` (claim) | `0x4d1c87ec…` |
| `0x1a9f207cc945ca982ee38029c84c35b6ca641c6c` | implementation (opt-in / reads) | `0x4d1c87ec…` |
| `0xa5d8daeb955c5a736abbd63f2740a77da0644844` | `BeaconProxy` trap config (verified) | `0x01c344b8…` |
| `0x8c81a374c54f61aabbc96ad4fa846940fec2f121` | `UpgradeableBeacon` (verified) | `0x01c344b8…` |

## Transactions

- `0xa7a26fca6e55035eaf9afd617ba37a7b0357abdd8f13aac2412634d63dda311b` (block 25,033,554, selector `0x96051d56`):
  router delegatecalls `0xd569cb69…`; calls trap config `0xa5d8…` (logs `ClaimMade(uint32)`,
  `ResponseFunctionInvoked(bool)`), `0x1975be6d…`, `0xb9edc971…`; router log `ClaimSubmitted(address indexed
  trapAddress, address indexed claimer, uint32 blockNumber)`. Calldata words: trap address, block number, two
  bytes32, two offsets, then 8 words (G1 point and G2 point plus two words), then an empty bytes.
- `0xf9850923c1919516f50eaa010c644f1d24773cbc1ea17addee10aab04d2659e7` (selector `0xea951b8b`): log
  `OperatorOptedIntoTrap(address indexed operator, address indexed trap)`.
- `0x9ff69a36dc17b54edcce4aee34008294ee2612d7ccf5afcf33f64c9fa7e2326e` (2026-06-15, selector `0x82fdfa3c`): delegatecall
  to `0x2a7a9480…` with 0.036 ETH.

## Bytecode

`0xd569cb69…` (20,390 bytes) and `0x1a9f207c…` (14,888 bytes): both contain
`30644e72…fd47` (BN254 base field) and `30644e72…0001` (group order) and one `STATICCALL` to `0x08` with input size
`0x0180` (two pairs). `0x7d3662f7…` and `0xd15d6cf0…` contain neither.

## Precompile trace

`data/agg/ecpairing_sizes_y1.parquet`: caller `0x01c344b8…`, pairs 2, calls 697 (year to March 2026).

## Holdings (block ~26,431,600)

Router 0.036 ETH plus dust tokens; trap configs at router CREATE nonces 12–51: code size 846 each, balances 0 to
0.002 ETH.
