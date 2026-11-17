# Review notes (Review15, 2026-11-17)

## Deployment

Socket DL mainnet addresses from `SocketDotTech/socket-DL` `deployments/prod_addresses.json` (key `"1"`):
Socket `0x943ac2775928318653e91d350574436a1b9b16f9`, TransmitManager `0xed037afbffc65a94e9cc592947e851fb2f730341`,
FastSwitchboard `0xd5a83a40f262e2247e6566171f9adc76b745f5cd`, OptimisticSwitchboard
`0xeaa15fd42d68b8334a3bb1e9bf8ca85babe83790`, ExecutionManager `0xfb4dcd94a051a1d2cf3eaf713a2ef686653884e0`,
ExecutionManagerDF `0x98cad9a205f1f7a7150241ef2d565d1702bce57c`, SignatureVerifier
`0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98`, SocketSafeProxy `0xeef6520437a6545b4f325f6675c4cd49812d457b`.

## Reads (RPC publicnode, block 26,431,597)

| Read | Result |
|---|---|
| Socket `owner()` | Safe `0xeef6…457b` (2 of 3: `0xf0e5b92c…`, `0xacee765b…`, `0xb0bbff63…`) |
| Socket `transmitManager__()` | `0xed037afb…` |
| Socket `executionManager__()` | `0x98cad9a2…` (ExecutionManagerDF) |
| TransmitManager `owner()` / `signatureVerifier__()` | Safe `0xeef6…` / `0xf1abf110…` |
| FastSwitchboard `owner()` / `signatureVerifier__()` (immutable) | Safe `0xeef6…` / `0xf1abf110…` |
| FastSwitchboard `timeoutInSeconds()` | 7200 |
| ExecutionManagerDF `owner()` / `signatureVerifier__()` (immutable) | Safe `0xeef6…` / `0xf1abf110…` |
| `hasRole(GOVERNANCE_ROLE, Safe)` on Socket and TransmitManager | true / true |
| Vault `0x5f3b…0cd3`, Vault `0xdff7…75f7`, ConnectorPlug `0x2dba…7d06` `owner()` | EOA `0xb0bbff6311b7f245761a7846d3ce7b1b100c1836` (nonce 910; also a Safe owner) |
| ConnectorPlug `0x4ab7…3660` `owner()` | EOA `0x3b88d6a4ccbd93c22c211c7f6e3ea8b1d30f81bf` |

## Escrow measurement

`plugs.json`: all `PlugConnected` logs of Socket since block 19,398,570 (Blockscout `getLogs`): 253 logs, 159 plugs
(152 ConnectorPlug); inbound switchboard of 242 of 249 connections is the FastSwitchboard.

`escrow-hubs.json`: for each plug, `hub__()` or `bridge__()` (the Vault/Controller behind a ConnectorPlug), then
Blockscout ETH + priced ERC-20 balances of the 123 distinct hubs at block 26,431,564: USD 5,589,023 in total
(Vault `0x5f3b…0cd3` sUSDe 3.60M, Vault `0xdff7…75f7` USDC 1.61M, WETH 148k, WBTC 145k, wstETH 88k). Controllers
(mint/burn SuperTokens) hold nothing; what a forged message could mint on them is not counted. Five plugs exposed
neither getter (`unresolved_plugs`; counters and switchboard plugs) and hold nothing (`plugs.json`).
