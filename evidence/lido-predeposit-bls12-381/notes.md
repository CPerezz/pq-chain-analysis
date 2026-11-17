# Review reads: lido-predeposit-bls12-381 (2026-11-17, Review07)

## Source (Sourcify, implementation `0xe78717192c45736df0e4be55c0219ee7f9addd0d`, `PredepositGuarantee`)

- `predeposit(_stakingVault, _deposits, _depositsY)` (PredepositGuarantee.sol line 397): `msg.sender` must be the
  node operator's depositor (line 406, `NotDepositor`); each deposit must be `PREDEPOSIT_AMOUNT` = 1 ether (lines 91,
  435); `verifyDepositMessage(...)` (line 438) → `BLS12_381.verifyDepositMessage` (line 275) checks the validator's
  BLS12-381 deposit signature over (pubkey, withdrawal credentials, amount) with the EIP-2537 pairing precompile
  (`contracts/common/lib/BLS.sol`, `BLS12_PAIRING_CHECK` 0x0f). The guarantor's 1 ETH per validator is locked.
- `proveInvalidValidatorWC(_witness, _invalidWithdrawalCredentials)` (line 563): if a CL proof shows the
  predeposited validator has other withdrawal credentials ("frontrun"), the vault is paid 1 ETH from the node
  operator's locked guarantee (lines 590–602).
- Upgrade: OssifiableProxy; admin can upgrade until ossified.

## On-chain reads (`cast`, publicnode, block 26,431,616)

- EIP-1967 implementation slot = `0xe78717192c45736df0e4be55c0219ee7f9addd0d`.
- `proxy__getAdmin()` = `0x3e40d73eb977dc6a537af587d48316fee66e9c8c` (Lido Agent; same Aragon Kernel
  `0xb8ffc3cd…` as stETH; Agent's `RUN_SCRIPT_ROLE`/`EXECUTE_ROLE` held by Dual Governance executor
  `0x23e0b465633ff5178808f4a75186e2f2f9537021`, see `evidence/lido-steth-permit-code-first/notes.md`).
- `proxy__getIsOssified()` = false; `isPaused()` = false.
- ETH balance = 3.0 ETH (node operators' guarantee balances), $5,435 at $1,811.62.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 2 (pairing calls), to March 2026.
