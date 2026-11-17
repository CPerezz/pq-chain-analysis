# Review reads: pimlico-paymaster-signer (2026-11-17, Review07)

The two `ShieldedVerifyingPaymaster` contracts first drafted here moved to `thirdweb-paymaster-signer`; their reads
are in `evidence/thirdweb-paymaster-signer/notes.md`.

## Source (Sourcify full matches)

- `SingletonPaymasterV7` (`0x7777…834c`) `src/SingletonPaymasterV7.sol`: `_validateVerifyingMode` (lines 159–177)
  and `_validateERC20Mode` (lines 186–) recover `ECDSA.recover(toEthSignedMessageHash(getHash(mode, userOp)), sig)`
  and accept if `signers[recovered]`; the result is returned as `validationData` to the EntryPoint, which then charges
  the paymaster's EntryPoint deposit for the operation's gas. `SingletonPaymasterV6` (`0x6666…c68b`) and
  `SingletonPaymasterV8` (`0x8888…2402`) have the same structure. `src/base/MultiSigner.sol`: `addSigner`/`removeSigner`
  are `onlyAdminOrManager`; `src/base/BasePaymaster.sol`: `withdrawTo`/`withdrawStake` are
  `onlyRole(DEFAULT_ADMIN_ROLE)` (lines 35, 68).

## Roles (`RoleGranted`/`RoleRevoked` in the creation receipts; `hasRole` via `cast` at block 26,431,569)

- Deployed 2025-03-18/27 by `0x4337001f…8084` and `0x433704c4…0c1` through factories; the constructor admin/manager
  was revoked in the same transaction and replaced by:
  - `DEFAULT_ADMIN_ROLE`: `0x4337aa1cb877d55fecf1f70110aed8c1d2ade2c9` (no code, nonce 83): `hasRole` = true on all three.
  - `MANAGER_ROLE`: `0xf1c9671104b48961807228cc0fad914c73aa2340` (ERC1967Proxy → `SimpleAccount`, an ERC-4337 account
    with an ECDSA owner): `hasRole` = true on all three.

## Exposure: EntryPoint deposits (`balanceOf(paymaster)` on the EntryPoint, `cast` at block 26,431,527; ETH $1,811.62)

| Paymaster | EntryPoint | Deposit ETH | USD |
|---|---|---|---|
| SingletonPaymasterV6 `0x6666…c68b` | v0.6 `0x5ff137d4…2789` | 1.7604 | 3,189 |
| SingletonPaymasterV7 `0x7777…834c` | v0.7 `0x00000000…a032` | 3.9318 | 7,123 |
| SingletonPaymasterV8 `0x8888…2402` | v0.8 `0x4337084d…f108` | 2.2884 | 4,146 |

Plus $576 of USDT/USDC held by `0x7777…834c` itself (block 26,431,214), not reachable through a forged signature.
Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 245,119 (V7), 137,743 (V8), 35,541 (V6).
