# Review notes: cow-aave-adapter-order-code-first (2026-11-17, Review18)

## Attribution

- Sourcify deployment record: deployed in tx `0x12842b16e307d9b98269cdde2397860ed4684e5f69e9eaafc789ab9f894ac497`
  (block 23,812,751) by EOA `0xdf0a18f9be8cecc1d4fde078d99ee2ed4885ac5e`.
- Verified source (`src/contracts/AaveV3AdapterFactory.sol` line 15, `BaseAdapterFactory.sol` line 23):
  `/// @author Aave Labs.` CoW code enters only as dependencies (`cowprotocol/flash-loan-router`, `cowprotocol/contracts`).
- Blockscout, transactions from the deployer: on 2026-10-09 it deployed `AaveV3AdapterV3Factory` /
  `AaveV3AdapterV4Factory` implementations and their adapters (`DebtSwapAaveV3Adapter`, `CollateralSwapAaveV4Adapter`,
  …) behind TransparentUpgradeableProxies created via Aave's `TransparentProxyFactory`
  `0xeb0682d148e874553008730f0686ea89db7da412`; on 2025-11-20 it called `transferOwnership` on this factory.
- Conclusion: the adapter factory is Aave Labs' code and deployment; project set to `aave`.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,494)

- `AaveV3AdapterFactory(0xdecc46a4…).owner()` = `0x187aae17d4931310b3fc75743e7f16bdc9ed77e9` (Safe, 5 of 8 at block
  26,431,214 per `onchain.json`); `paused()` = false. Not a proxy (no EIP-1967 slots, `onchain.json`).
- Newer factories, same owner Safe: proxies `0xd2cc30cb0e77b80a34b879ccb6da67799e4ecd83` (impl
  `0xde33afe502c8582c706d669a6808e6d24c15742d`, `AaveV3AdapterV3Factory`), `0x0c6f0d008b5ee6cdfbb8bf1cfb0148052e96ac14`,
  `0xfdfa036213c375808135744e865767fd90897f0a`.

## Source (Sourcify)

- `BaseAdapterFactory.verifyOrderSignature` (line 151): EIP-712 digest over the adapter order, then
  `SignatureChecker.isValidSignatureNow(orderOwner, digest, signature)` (line 172).
- OpenZeppelin `SignatureChecker` (v5.x file with ERC-7913 support), line 33: `if (signer.code.length == 0)` →
  `ECDSA.tryRecover`, else `isValidERC1271SignatureNow` with the full signature (line 53).
- Newer implementations `0xde33afe5…`, `0xaed8fb57…`, `0x38a9bdc0…`: OpenZeppelin v5.6.0 `SignatureChecker`, called
  as `SignatureChecker.isValidSignatureNowCalldata(orderOwner, digest, signature)` (`BaseAdapterV3Factory.sol` line
  211); the library checks `signer.code.length == 0` first. Same code-first pattern.

Yearly pre-quantum calls (`data/report/curated_contracts.csv`): `txs_y1` 18,605 ecrecover calls.
