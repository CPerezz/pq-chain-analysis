# Review notes (Review08, 2026-11-17)

Unverified implementations. Reads at block 26,431,454 (listed vault) and 26,431,544 (siblings).

Listed vault `0xcd81502214d405f40ff14884f2b3962a2f822d67`:

| Read | Result |
|---|---|
| EIP-1967 implementation slot | `0x2e9f95c5327e3c6c30d6601b4bb1b527defea577` |
| EIP-1967 admin slot | `0x0a19711f1b1696bf1fb93478bb3e5f454a3ab07b` (ProxyAdmin, created by the proxy itself) |
| ProxyAdmin `owner()` and vault `owner()` | `0x91fd09982efff951df4ff80e7e78fee1981ac51d` (SafeProxy) |
| Safe `getThreshold()` / `getOwners()` | 2 / `0xf3747464…`, `0xe893e2a5…`, `0x544f54b9…`, `0x2be56f64…`, `0x9af1025d…` |
| Creator (Blockscout) | EOA `0x2900cb559cf7034f92dbf43d0c13da89fdb4fc7c` (no ENS or tag), 2026-01-07 |

Implementation bytecode: `isValidSignature(bytes32,bytes)`, `setOperator(address,bool)` / `isOperator(address)`,
`setWhitelist` / `isWhitelist`, `withdraw(address,address,uint256)`, `multiSend(address[],address)`, `wrap` / `unwrap`,
`initialize(address,address[],address[],uint256)`, `maxNum()`; strings `at least 65 sig`, `not permitted`,
`recipient not in whitelist`, `unwrap too frequently`; OpenZeppelin `ECDSA` `n/2` constant present. INFERRED:
`isValidSignature` returns the magic value when the signature recovers to an operator.

Fills: `dagSwapByOrderId` on OKX `DexRouter` `0x5e1f62dac767b0491e3ce72469c217365d5b48cc` (e.g. tx `0x2b4a332d25…`).
On 2026-03-25 the Safe (`execTransaction` from owner `0xe893e2a5…`) moved 190,259 USDC, 654,614 USDT, 267.5 WETH and
2.43 WBTC from the vault to `0xdd4bdbbb…`. Last activity on 2026-04-14 (a pass-through of 4 BBTC).

Same deployer, same owner Safe, same selector set (`isValidSignature`, `setOperator`, `n/2` constant):

| Vault | Kind | Implementation | Admin / owner | Priced tokens (Blockscout) | ETH | Last token transfer |
|---|---|---|---|---|---|---|
| `0x2e104fb25676c7c3e3a5a648865cca1db15dcc71` | EIP-1967 proxy | `0xbf95581001997a4ad56b741575cdf94820b2e113` | ProxyAdmin `0x88e0ab33…`, owner Safe `0x91fd0998…` | about USD 664,607 (USDC 466k, USDT 153k, WETH 46k) | 0 | 2026-11-16 |
| `0x8377d393cca7ee75b4e91c612a967e89442d460d` | not a proxy | — | owner Safe `0x91fd0998…` | about USD 272,652 (WETH 173k, USDC 100k) | 0 | 2026-11-16 (via a contract Blockscout names `DexRouter`, `0x8feab81d…`) |
| `0xdd4bdbbb5e2e69165397f4af16ae520e549da1e4` | EIP-1967 proxy | `0x1bdb1d6bbe6d3bd03ec2897bcce530926493680f` | ProxyAdmin `0xbc6eeb95…`, owner Safe `0x91fd0998…` | about USD 16 | 0.01 | 2026-08-16 |
| `0x65ec88a7eeee54a6b4cf6604d43edae415043fd2` | EIP-1967 proxy | `0x67458375dbe3427874f204d96d2b0ea0522efa69` | owner EOA `0xe893e2a5…` (a Safe signer) | 0 | — | 2026-08-08 |
| `0x803e29813751e6583f8e416bffeb52a99f1df69d` | EIP-1967 proxy | `0xfa355f61cf2e0c8919e825c8e390376a58a2cadd` | owner EOA `0xe893e2a5…` | 0 | — | none |

The first three were created after the precompile census window (to March 2026); `0x65ec88a7…` (2025-12-11) was not
in the census list either. `ecrecover` use in these siblings is INFERRED from the bytecode, not traced.
Attribution: fills go through OKX's DEX router, but the deployer and the Safe carry no OKX label; ownership by OKX is
not established.
