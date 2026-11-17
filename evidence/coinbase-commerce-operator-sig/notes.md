# Review notes (Review12, 2026-11-17)

- Source: Sourcify full source of `0x1fa57f879417e029ef57d7ce915b0aa56a507c31`, `contracts/transfers/Transfers.sol`.
  - `validIntent(_intent, sender)` (lines 79–124): hash of (recipientAmount, deadline, recipient, recipientCurrency,
    refundDestination, feeAmount, id, operator, chainid, sender, this); `ECDSA.recover(...)` must equal
    `_intent.operator`; then deadline, non-zero recipient, intent id not yet processed.
  - `sender` is `_msgSender()` in every payment function (lines 153, 172, 225, 272, 298, 347, 390, 417, 463) except
    `subsidizedTransferToken` (line 513), where it is the payer whose EIP-2612 permit is consumed.
  - `operatorIsRegistered` (line 128) only requires `feeDestinations[operator] != 0`; `registerOperator()` /
    `registerOperatorWithFeeDestination()` (lines 789–797) are permissionless.
  - Owner: `pause`/`unpause` (lines 809–814), `setSweeper`; sweeper: `sweepETH` etc. (`Sweepable.sol`).
- cast at block 26,431,459: `owner()` = 0x8899cecfd929504414696c734eaf6300fdbb428c (no code: EOA); `paused()` = false.
- Blockscout logs (v2 `addresses/<addr>/logs`, read 2026-11-17): latest `Transferred` events are at block 24,787,942
  (2026-04-01), operator 0x8fccc78dae0a8f93b0fe6799de888d4c57e273db.
- Blockscout transactions: later calls revert (2026-10-24 `swapAndTransferUniswapV3Native`, revert `ExpiredIntent()`,
  tx 0x9ebc6de5…; 2026-08-04 `sweepETH` reverts; 2026-07-21 reverted payment).
