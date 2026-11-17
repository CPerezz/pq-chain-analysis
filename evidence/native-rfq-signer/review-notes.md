# Review reads: native-rfq-signer (2026-11-17, Review17)

Sourcify sources: NativeRouter `0x8a2ddc0461fcf96f81a05529bed540d4f1eb2a00` (bundle includes NativeRFQPool and
CreditVault) and NativeRFQPool `0xc419e67388df0c0cfad15584fc5fc7e67a234c17`.

- `NativeRouter.tradeRFQT` requires `isNativePools[quote.pool]` and `_verifyRFQSignature(quote)`:
  `ECDSA.recover(digest, quote.widgetFeeSignature)` must be in `signers` (owner `setSigner`). `externalSwap` uses
  `_verifyExternalSwap`: `ECDSA.recover(digest, params.signature)` in `signers`.
- `NativeRFQPool.tradeRFQT` (only callable by `router`): `_verifyPMMSignature` requires `rfqSigners[quote.signer]`
  and `quote.signer == ECDSA.recover(digest, quote.signature)`; then, for a credit pool,
  `ICreditVault(treasury).swapCallback(signer, …)` books the trade to the market maker's position and
  `_transferFromTreasury` does `safeTransferFrom(treasury, recipient, buyerTokenAmount)`.
- `CreditVault`: `swapCallback` only from `creditPools[msg.sender]`; `settle`, `removeCollateral`, `liquidate` check
  `ECDSA.recover(digest, signature) == signer`.
- No contract is a proxy (EIP-1967 implementation slot 0 on all four routers).

On-chain reads, latest block 26,431,551-26,431,705 (2026-11-17):

| Contract | treasury | router | creditPool in vault | vault USDC/WETH allowance to pool |
|---|---|---|---|---|
| pool `0xc419e673…` | `0xe3d41d19…` | `0x8a2ddc04…` | true | max / max |
| pool `0x5d1a3436…` | `0xe3d41d19…` | `0xa540ec8c…` | true | max / max |
| pool `0x9af2f3c0…` | `0xe3d41d19…` | `0x0f9f2366…` | false | 0 / 0 |

- Routers: `owner()` of all four = Safe `0x83fc28e6962e41e38f7854308eff827e3f6b906b`, `getThreshold()` = 3, 5 owners.
  `paused()`: `0x8a2ddc04…` false, `0xa540ec8c…` false, `0x0f9f2366…` true, `0xa42c9f74…` true.
  `isNativePools`: `0x8a2ddc04…`→`0xc419e673…` true, `0xa540ec8c…`→`0x5d1a3436…` true, `0x0f9f2366…`→`0x9af2f3c0…` true.
- Pools: `owner()` = Safe `0x83fc28e6…`.
- CreditVault `0xe3d41d19564922c9952f692c5dd0563030f5f2ef`: `signer()` = `0x0b89c5eb76b15a4b09b05b01c953e19dedf80a5e`;
  `owner()` = `0x9b9dc7c56e18cfda57d402ca7ded491b1544dc56` (contract, unverified, not a Safe, no `getMinDelay`); no
  EIP-1967 implementation; ETH 0.
- CreditVault ERC-20 holdings (Blockscout `/tokens`, priced, run on the remote box 2026-11-17): $6.79M — WETH $2.16M,
  USDT $2.02M, USDC $1.74M, cbBTC $506k, WBTC $351k, others < $5k.

## Follow-up: CreditVault in `contracts[]` (2026-11-17)

- Sourcify exact match at the vault's own address (`src/CreditVault.sol:CreditVault`).
  - `settle` (171), `removeCollateral` (203): `onlyTraderOrSettler(trader)` (620: `traders[trader]` and the caller is
    the trader or its settler); signature check; `safeTransfer` to `traderToRecipient[trader]`; daily
    `_updateRebalanceCap`.
  - `liquidate` (250): `onlyLiquidator`; signature check; pays `liquidatorToRecipient[msg.sender]` and claimed
    collateral.
  - `_verifySettleSignature` (542), `_verifyRemoveCollateralSignature` (566), `_verifyLiquidationSignature` (590):
    EIP-712 digest, `ECDSA.recover(digest, signature) == signer`.
  - `setSigner`, `setCreditPool`, `setAllowance`, `setTrader`, `setLiquidator`, `supportMarket` are `onlyOwner`.
- Latest block 26,431,766: EIP-1967 implementation slot 0 (not a proxy).
- Blockscout direct transactions: last `settle` 2026-07-14 (block 25,531,299); none 2026-10-16 to 2026-11-16.
