# Consumers and controls: okx-wallet-link-groth16

Read 2026-11-17 (latest block about 26,431,600; `ethereum-rpc.publicnode.com`, traces from `eth.drpc.org`
`debug_traceTransaction` with callTracer).

## Verifier

`0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88`: 4,755 bytes, not verified (Sourcify, Blockscout). Selector `0x76852571`
= `verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[37])`. In traces it calls `ecMul` (0x07) and `ecAdd` (0x06)
37 times each, then `ecPairing` (0x08) once: a Groth16 verifier with 37 public inputs. No storage, no owner, not a proxy.
Created by `DeployFactory` `0xfac897544659fb136c064d5428947f5bc9cc1fa2` (Sourcify verified), which also created every
contract below.

## Call chain (txs `0xc4d6534c…6eda` block 26,423,955 and `0x7ce72105…4622` block 26,423,555)

1. Relayer EOA `0x883a95fdf8df78e7128fced0e9d931a687ff542f` calls Multicall `0x4ebc36dc…` or directly `0x6f714629…`.
2. `SmartWalletFactory` `0x5c328f3b5f117ffc693378a2c5b16c4f80f86295` (Blockscout verified; source identical to
   `okxlabs/okx-smart-wallet-evm` `src/SmartWalletFactory.sol`; `IMPLEMENTATION()` = `0x36d3cbd8…`) creates the user's
   smart wallet (ERC-1967 proxy, e.g. `0xf8d9ce44…`) when needed.
3. Clone factory `0x6f714629052538051c41d5965369bec0eea594e3` creates an EIP-1167 clone of `0xd8f8b2eb…` and calls
   `initialize(bytes32[] keyHashes, address[] validators)` with validators `[0xea93c8d9…, 0x98ab855d…]`.
4. The clone's `0x98c2f162` execute entry staticcalls each validator with `0x8d75716e`:
   - ZK validator `0xea93c8d93b053ba360dd720986147559f5550b38`: `project()` = "OKX CEX Wallet", `verifier()` =
     `0xc3dace2f…` (pure: fixed in code), `registry()` = `0x3175dd6c…`; it asks the registry
     `isKeyHashValid(bytes32,bytes32)` and then calls `verifyProof`.
   - ECDSA validator `0x98ab855dac8dcc24e47f1f5dbf68561ce412dc40`: `ecrecover` returns `0x52e6e54053a89af28a7c4017a147d423b46860b6`
     (no code, nonce 0) in both sampled transactions, for two different users: a shared service key.
5. The clone consumes a nonce at `0xc7cee046…` and calls the user's smart wallet `execute(Call[])`, which here runs
   `addOwner(bytes32,address,uint256)` on that wallet.

## Registry controls

| Read | Value |
|---|---|
| `0x3175dd6c….owner()` | TimelockController `0xca9b5728cb353afcf6e41afd8b71f7ceb0aa703b`, `getMinDelay()` 43,200 s; proposer/canceller EOA `0x5f9fd2c8…`, executor `0xe0c77584…`, admin EOA `0xa07ae4bd…` (roles from creation tx `0x328bf99f…`; admin and proposer re-checked with `hasRole`) |
| `0x3175dd6c….pauser()` | EOA `0xa07ae4bdfa7ba8bc0e8a8525bcc768300a8970bb` |
| `paused()` | false |
| Simulation (`cast call --override-state-diff`, slot 0 paused bit set) | `isKeyHashValid` for the sampled key returns false, and the ZK validator's `0x8d75716e` returns 0 for the sampled proof that returns 1 unpaused |

## Wallets reached

Census families for logic `0x36d3cbd8…`: 1,378 ERC-1967 proxies and 183 EIP-7702 EOAs. `AccountCreated` events from
`SmartWalletFactory` since block 23,732,085: see `okx-accounts.json`.
