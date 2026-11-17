# Review reads: everclear-fee-signer (2026-11-17, Review07)

## Source (Sourcify)

- `FeeAdapter` `0x15a7ca97d1ed168fb34a4055cefa2e2f9bdb6c75`, `src/contracts/intent/FeeAdapter.sol`: every
  `newIntent`/`newOrder` path calls `_handleFees` (lines 394–418), which calls `_verifySignature` (lines 381–387):
  `ECDSA.recover(toEthSignedMessageHash(keccak256(abi.encode(tokenFee, nativeFee, inputAsset, deadline))), sig) ==
  feeSigner`, then sends `tokenFee`/`nativeFee` to `feeRecipient`. `updateFeeSigner` is `onlyOwner` (lines 75–79).
- `FeeAdapterV2` `0xd0185bfb8107c5b2336bc73ce3fdd9bfb504540e` (Everclear docs list it as the Ethereum FeeAdapter),
  `src/contracts/intent/FeeAdapterV2.sol`: `_verifySignature` (lines 423–436) hashes the call data with
  `address(this)` and `block.chainid` and `ECDSA.recover(...) == feeSigner`; e.g. `newOrderSplitEvenly` (lines
  159–172).

## On-chain reads (`cast`, publicnode, block 26,431,599)

- Both adapters: not proxies (EIP-1967 slot 0); `owner()` = `feeRecipient()` =
  `0xa02a88f0bbd47045001bd460ad186c30f9a974d6` (Safe, threshold 2 of 6); `feeSigner()` =
  `0xd148c7f37b346a4bd8e14f8c1f181f5f640481c8`; ETH 0. `spoke()` (V1) = `0xa05a3380889115bf313f1db9d5f335157be4d816`.

## Activity and holdings (Blockscout, 2026-11-17)

- V1: last transactions `newIntent`/`newOrder` on 2025-11-12; Xatu found none in 2026-10-16 to 2026-11-16.
- V2: deployed 2025-11-11 (block 23,776,636) by `0x2d64a7617bf0761fe715a17693a4bff1abf445b0`; last transactions
  `newIntent` on 2026-04-08; holds 0.011998 USDC and 0.009998 USDT (≈ $0.02) plus unpriced dust.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`, V1): `txs_y1` 12,631.
