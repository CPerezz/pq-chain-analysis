# Review notes (Review08, 2026-11-17)

Unverified. Reads at block 26,431,544 unless noted.

| Call | Result |
|---|---|
| `owner()` | `0xc493f943a1fd910d01dcabea86e61415ce43e787` (EOA, 0.26 ETH) |
| `reactor()` | `0x6000da47483062a0d734ba3dc7576ce6a0b645c4` (Blockscout name `ExclusiveDutchOrderReactor`, UniswapX) |
| `wNATIVE()` | WETH |
| `0x092fd7e9`, `0x8d5c93bd`, `0x99757fce`, `0xc2182878` (no args) | revert `Liq: onlyOwner` |
| holdings | about USD 1.46 of spam tokens, no ETH (onchain.json, block 26,431,214) |

Bytecode selectors: `isValidSignature(bytes32,bytes)`, `takerInteraction(...)` (1inch Limit Order Protocol v4 taker
hook), `setLimitOrderProtocol`, `setReactor`/`reactor` (UniswapX), `swapERC20()` (AirSwap), `cashier(address)`,
`withdrawalWhitelist(address)`, `withdrawNative`, `setOwner`, unresolved `0x2f0dd388(address,address,bool)`.
OpenZeppelin `ECDSA` `n/2` constant present. INFERRED: `isValidSignature` returns the magic value when an ECDSA
signature recovers to a registered signer, which makes the vault the maker of RFQ orders on these venues.

Deployer: EOA `0x9e056868b204ffe34351eb00a404e3fc9eec5192` (no ENS or tag). It created this vault on 2025-03-07 and
configured it, and created siblings with identical selectors:

| Address | Created | owner | Priced holdings | Last token transfer |
|---|---|---|---|---|
| `0xb02f39e382c90160eb816de5e0e428ac771d77b5` | 2024 (older version) | `0xc493f943…` | 0 | 2026-10-31 (incoming dust) |
| `0x935cd8c1b23b0a9f02428e3792e797165e3ca8b2` | 2025-12-11 | `0xfb61bf3079f47f644bce9c4d36b55d608a186778` (EOA) | about USD 1 | 2026-09-29 |

Flows (Blockscout token transfers): the vault filled orders through CoW Protocol `0x9008d19f…` and other venues until
2026-05-07. That day it sent 1,268,771 USDC, 206,282 USDT and 1,291 WETH to `0xd4d5db5ec65272b26f756712247281515f211e95`
(a 68-byte proxy contract created by `0xc3ebddea…`, now empty). Later inflows are small exchange-payout dust.

Usage: `curated_contracts.csv`: 524,574 transactions with `ecrecover` in this contract in the year to March 2026.
