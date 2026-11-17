# Review notes (Review08, 2026-11-17)

Unverified. Reads at block 26,431,544 unless noted.

| Call | Result |
|---|---|
| `owner()` | `0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85` (EOA) |
| `verifyingSigner()` | `0x7e416860b6bbb0db05563116ce3750798c01e825` (EOA) |
| `entryPoint()` | `0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789` (v0.6) |
| EntryPoint `balanceOf(0x1c6ad754…)` / `getDepositInfo` | 0 / (deposit 0, not staked) |
| ETH / tokens held by the paymaster | 0 / 0 (onchain.json, block 26,431,214) |

Bytecode: selectors of the eth-infinitism v0.6 `VerifyingPaymaster` (`validatePaymasterUserOp`, `getHash`,
`parsePaymasterAndData`, `verifyingSigner`, `deposit`, `withdrawTo`, `addStake`) plus `addOrigin(address)` /
`removeOrigin(address)`. Strings: `ECDSA: invalid signature`, `VerifyingPaymaster: invalid signature length in
paymasterAndData`, `Invalid tx origin`, `Invalid origin`. The secp256k1 `n/2` constant is present (OpenZeppelin
`ECDSA`). INFERRED: the signature in `paymasterAndData` is recovered and compared with `verifyingSigner`, and
`tx.origin` must be on an allow-list of bundlers.

Deployment: created 2024-12-20 through the CREATE2 factory `0x4e59b448…` by EOA
`0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c` (no ENS or Blockscout tag), which also deployed the Biconomy ECDSA module
copy `0xba418fa6…` (see `biconomy-ecdsa-validator`). Its CREATE2 deployments of 2025-12-31 to 2026-01-04 include two
more paymasters with the same code size and owner:

| Address | verifyingSigner | owner | EntryPoint v0.6 / v0.7 deposit | ETH |
|---|---|---|---|---|
| `0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4` | `0x7e416860…` (same) | `0xbe4c70a0…` | 0 / 0 | 0 |
| `0x8cbd4a19f3a538d4ba85b6899263586a214ddc0a` | `0x67575ef3737dd3e4921297ba04b4ee281e4b10be` | `0xbe4c70a0…` | 0 / 0 | 0 |

Usage: `curated_contracts.csv`: 70,948 transactions with `ecrecover` in `0x1c6ad754…` in the year to March 2026.
