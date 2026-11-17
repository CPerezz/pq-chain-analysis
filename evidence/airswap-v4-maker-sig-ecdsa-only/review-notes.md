# Review reads: airswap-v4-maker-sig-ecdsa-only (2026-11-17, Review17)

- Sourcify full source of `0xd82fa167727a4dc6d6f55830a2c47abbb4b3a0f8` (SwapERC20, solc 0.8.17, OpenZeppelin):
  - `swap` / `swapAnySender` -> `_check` (SwapERC20.sol 648-699): `ECDSA.tryRecover(orderHash, v, r, s)`; signatory
    must be non-zero and equal `authorized[signerWallet]` if set, else `signerWallet`. No ERC-1271 call anywhere.
  - `swapLight` (lines 236-330): same `ECDSA.tryRecover` check.
  - Then `IERC20(signerToken).safeTransferFrom(signerWallet, recipient, signerAmount)` (lines 137, 205, 303): the
    signer is the maker (end user), whose allowance is spent. The draft's "protocol operator single key" was wrong.
  - `onlyOwner` setters: `setProtocolFee`, `setProtocolFeeLight`, `setProtocolFeeWallet`, `setRebateScale`,
    `setRebateMax`, `setStaking`. No upgrade path.
- On-chain (onchain.json, block 26,431,214): no proxy; `owner()` = Safe `0xf8bb149f9525875fa47b8cc632d368eb600faba3`
  (2 of 3); ETH 0, tokens $0.
- Blockscout `/addresses/0xd82fa167…/transactions` (2026-11-17): latest direct calls `cancel` 2025-11-17 (block
  23,815,951), `swap` 2025-07-16, `swapAnySender` 2025-03-03. Creator `0x3768bec96a282273fe3756a92c4f6d7d06aa289b`.
- Precompile trace: last `ecrecover` use 2025-09-17; none in 2026-03-18 .. 2026-11-16 (activity.json).
- `data/report/curated_contracts.csv`: txs_y1 20,820, usd_tx_y1 $0.99M (window before 2026-03).
