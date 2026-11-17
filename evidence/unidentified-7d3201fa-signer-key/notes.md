# Review notes (Review12, 2026-11-17)

- Source: Sourcify `src/v0.7/Paymaster.sol` of 0x7d3201fa7a85c0a5f9fa1c0c6b9d0b784368d2ac (deployment tx
  0xb6df6e5a8a8b754c7ba392f8ef6b4949566f909a6a72493711d516016f38f495, block 22,318,390, deployer
  0xd87df9fd27b9a30fe27e7b294caaa4673f34b6b1, an EIP-7702 EOA).
  - `_validatePaymasterUserOp` (lines 82–108): parses (validUntil, validAfter, token, amount, signature) from
    `paymasterAndData`; requires a 65-byte signature; `signer != ECDSA.recover(toEthSignedMessageHash(getHash(...)))`
    returns SIG_VALIDATION_FAILED.
  - `_postOp` (lines 110–120): `safeTransferFrom(token, userOp.sender, treasury, amount)`.
  - `updateSigner`, `updateTreasury` (lines 135–143) and BasePaymaster `withdrawTo`, `addStake`, `unlockStake`,
    `withdrawStake` are `onlyOwner`; `deposit()` is public.
- cast (https://eth.drpc.org) at block 26,431,610: `signer()` = 0x5437edbb73bcbbad2c7fe2cca23969e3b8e5baa4 (EOA);
  `treasury()` = 0x480a825bed6cdba9da81cc01faacd12166761dec (Blockscout name `PaymasterBuffer`, created by
  0xd3da45475a96dddb7395fc449234e1604c405c6a); `owner()` = Safe 0x8cef85a571bef5379ef1cc9952eae7e109a38a0f,
  `getThreshold()` = 3 (6 owners, onchain.json); `entryPoint()` = 0x0000000071727de22e5e9d8baf0edac6f37da032;
  `getDeposit()` = 0 and EntryPoint `getDepositInfo` = (0, false, 0, 0, 0).
- Attribution tried: Blockscout names/tags of deployer, treasury, Safe and signer (none); Sourcify metadata (no
  author/repo); web search for the paymaster, treasury and Safe addresses (same addresses used on BSC, Arbitrum,
  Polygon and Base; no project named). Operator not identified.
