# Review reads: uniswapx-cosigner (2026-11-17, Review07)

## Source (Sourcify, `0x00000011f84b9aa48e5f8aa8b9897600006289be`, `V2DutchOrderReactor`)

`src/reactors/V2DutchOrderReactor.sol`:

- `_resolve` (lines 43–69): `orderHash = order.hash()`; `_validateOrder(orderHash, order)`;
  `_updateWithCosignerAmounts(order)`; input and outputs decay between `cosignerData.decayStartTime` and
  `decayEndTime`; `handleExclusiveOverride(cosignerData.exclusiveFiller, decayStartTime, exclusivityOverrideBps)`.
- `_validateOrder` (lines 111–123): `ecrecover(keccak256(abi.encodePacked(orderHash, abi.encode(order.cosignerData))), v, r, s)`
  must equal `order.cosigner` (an address inside the swapper-signed order). Raw `ecrecover`, no ERC-1271.
- `_updateWithCosignerAmounts` (lines 83–104): cosigner input must be ≤ `baseInput.startAmount`, outputs ≥
  `baseOutputs[i].startAmount`; the cosigner cannot move the order outside the swapper's signed start/end amounts.
- `_transferInputTokens` (lines 72–81): swapper funds move through `permit2.permitWitnessTransferFrom` with the
  swapper's own signature (Permit2 checks account code first: see `uniswap-permit2-code-first`).

## On-chain reads (`cast`, publicnode, block 26,431,621)

- EIP-1967 implementation slot = 0 (not a proxy); `permit2()` = `0x000000000022d473030f116ddee9f6b43ac78ba3`.
- `owner()` = `0x1a9c8182c09f50c8318d769245bea52c32be35bc` (Blockscout name `Timelock`; `delay()` = 172,800 s;
  `admin()` = `0x408ed6354d4973f66138c91495f2f2fcbd8724c3`, Uniswap governor). The owner can only set the protocol fee
  controller (`feeController()` = 0 now); it cannot change the cosigner check.
- Deployed 2024-05-07 through the CREATE2 factory by `0x496d57839975e5c0bd36d39ffa27336b078b1b16`.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 525,706 `ecrecover` transactions.
