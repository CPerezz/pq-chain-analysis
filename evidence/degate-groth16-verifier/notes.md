# Review notes (Review23, 2026-11-17)

Reads at block ~26,431,700 (https://ethereum-rpc.publicnode.com):

- DeGate exchange `0x9c07a72177c5a05410ca338823e790876e79d73b` (OwnedUpgradabilityProxy → ExchangeV3
  `0xc56c1dfe…`, verified): storage slot 6 (`ExchangeData.State.blockVerifier`) =
  `0xe3b7fe3ce0fa54c5ac7f48e7ed9e52da045be4d6`; slot 8 (`depositContract`) = `0x54d7ae423edb07282645e740c046b9373970a168`;
  `LoopringV3 0x9385acd9….blockVerifierAddress()` = `0xe3b7fe3c…`. ExchangeV3 has no function to change the
  verifier after genesis (`ExchangeGenesis.initializeGenesisBlock` sets it once).
- `isShutdown()` = true; `isInWithdrawalMode()` = false; `getBlockHeight()` = 13,434.
- Last `submitBlocks` (via exchange owner `LoopringIOExchangeOwner 0x9b93e47b…`, `open()` = false, owner MultiSigWallet
  `0x2028834b…`, required 4 of 6): 2025-06-27; last exchange transactions `withdrawFromApprovedWithdrawals` 2025-06-28.
- `BlockVerifier 0xe3b7fe3c….owner()` = `0xacd3a62f3eed1bfe4ff0ec8240d645c1f5477f82` (EOA); verification keys are
  hard-coded (`VerificationKeys.sol`); the contract exposes only `verifyProofs`, `isCircuitRegistered`,
  `isCircuitEnabled`, `getVerificationKey`.
- Proxy owners: exchange `0x9c07…` → Timelock `0x0d2ec0a5…`; deposit contract `0x54d7…` → Timelock `0xf2991507…`.

Escrow: DefaultDepositContract `0x54d7…` holds $159.57 of Blockscout-priced ERC-20s (USDC 147.9, USDT 10.0, dust) and
0.0000009 ETH; unpriced tokens not counted.
