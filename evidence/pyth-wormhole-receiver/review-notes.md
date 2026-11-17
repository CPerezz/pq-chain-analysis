# Review reads: pyth-wormhole-receiver (2026-11-17, Review17)

On-chain values are in [`onchain.json`](onchain.json) (latest block 26,431,744-26,431,775).

## How the contracts connect

- Pyth price-feed contract `0x4305fb66…` (EIP-1967 proxy, implementation `0x3f38404a…`, unverified) returns
  `wormhole()` = `0x3a2dd09b…`. Its implementation has `updatePriceFeeds(bytes[])`, `executeGovernanceInstruction(bytes)`
  and `upgradeTo(address)`; governance data source = chain 1, emitter `0x5635979a…`; price data source = chain 26.
  Blockscout: 866 direct transactions 2026-10-16 to 2026-11-16, last `updatePriceFeedsIfNecessary` 2026-11-17.
- `0x3a2dd09b…` (EIP-1967 proxy, implementation `0x8d289cdd…`, unverified; Sourcify matched only the generic proxy)
  has `parseAndVerifyVM` and `submitNewGuardianSet` and no upgrade selector. Current guardian set index 1 with 5 keys
  (quorum `5 * 2 / 3 + 1` = 4 if it uses Wormhole's `quorum()`; INFERRED, source not available). Blockscout: last
  direct transaction `submitNewGuardianSet` 2026-09-04 (relayed
  by `0x78357316…`); called internally up to 2026-11-17.
- Pyth executor `0xccd7e24e…` (EIP-1967 proxy, implementation `0x395921b6…`, unverified) is its own `owner()` and has
  `execute(bytes)`, `getOwnerChainId()` = 1, `upgradeTo`, `upgradeToAndCall`. Tx `0x960a2d4c…` (block 26,306,172,
  Blockscout internal calls): executor staticcalls `0x74f09cb3…` (which delegatecalls `0x87047526…`) and then calls
  PythLazer `0xacea761c…`.
- `0x74f09cb3…`: guardian set index 7, 19 keys, identical to the Wormhole core's set 7; `parseAndVerifyVM`,
  `submitNewGuardianSet`, no upgrade selector. Creator `0x78357316…`, which relayed its `submitNewGuardianSet` VAAs
  (2023-08-09 to 2026-06-25).
- PythLazer `0xacea761c…` (UUPS, implementation `0xa089a10d…`, Sourcify exact match `src/PythLazer.sol`, version
  0.3.0): `owner()` = executor; `_authorizeUpgrade` is `onlyOwner`; `updateTrustedSigner` is `onlyOwner`.
  `verifyUpdate(update)` (lines 130-172): `ECDSA.tryRecover(keccak256(payload), v, r, s)` and
  `isValidSigner(signer)` (trusted and not expired). One trusted signer: `0x26fb61a8…`, expiry 2077357410 (2035-10-30).
  `verification_fee` = 0. Blockscout: last direct `verifyUpdate` 2026-10-30; called internally up to 2026-11-17.

## Not measured

What Pyth prices secure in Ethereum protocols (lending collateral, perps) is not measurable from these contracts; the
contracts hold 0.0034 ETH (Pyth) and 59,200 wei (PythLazer).
