# Review notes (Review08, 2026-11-17)

All three contracts are unverified. Reads at block 26,431,454 unless noted.

| Contract | Creator (Blockscout) | `getOwner()` | `getFee()` | ETH | Priced tokens |
|---|---|---|---|---|---|
| `0x00c21ca8…` | `0xef482680…` (ENS `gamma.satoris.eth`, EOA) | `0xef482680…` | 1e17 | 0 | HEX ~USD 0.88 |
| `0x2d53a516…` | `0xef482680…` | `0xef482680…` | 9.5e17 | 0 | ~0 |
| `0x32d96667…` | `0xef482680…` | `0xef482680…` | 9.5e17 | 0 | 0 |

Bytecode (`cast selectors`): `setOwner`, `getOwner`, `whitelistAddress`, `blacklistAddress`, `setFee`, `getFee`,
`sweep(address[],address)`, `transferToken`, `transferETH`, `getFlashToken(address)`, `getNonce(address)` /
`getNonce()`, and unresolved entry points taking arrays of
`(bytes,uint256,address,address,uint256,uint256)` (swap legs) and structs
`(address,uint256,address,bytes,uint256,uint256,bytes)` ending in a `bytes` field (INFERRED: a signature).
None contains the secp256k1 `n/2` constant. In a sampled transaction
(`0x6cada0dab77513939dae56481c9585c0da691062e0df865796069a857a1ea221`, 2026-06-21, entry `0xc8512104`), `0x00c21ca8…`
takes a Morpho flash loan of 31,089 USDC, trades USDC/USDT through `0x634826fb…` (same creator), repays, and sends
USD 0.23 profit to `0xef482680…`. During the loan it delegatecalls `0x878978b5…` (same creator), whose selectors are
`onMorphoFlashLoan`, `MORPHO()` and `0x677e86e2((address,uint256,address,bytes,uint256,uint256,bytes),bool)`, and
whose bytecode contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA`). INFERRED: the signature on the trade
instruction is recovered there, in the executor's context; who must sign it (owner or whitelisted address) was not
established.

Activity: `0x00c21ca8…` last direct calls on 2026-07-06 (`0x092b25e9` from `0xce43e83d…`) and on 2026-06-21
(`0xc8512104` from several EOAs). `0x2d53a516…` is now only read: on 2026-11-04, `0xcb0151ac…` (a newer executor by
the same creator, same selector family plus `arbitraryCall`, with library `0x765b6826…` that also contains the `n/2`
constant) staticcalls it.

Sibling not in the census: `0xcb0151ac9479a6a0261622baa63ae843c9793d45` (owner `0xef482680…`, ETH 0.00002, no priced
tokens; active 2026-11-04; Morpho flash-loan arbitrage, profit to `0xef482680…`).
