# Review notes (Review23, 2026-11-17)

Reads at block 26,431,695 (https://ethereum-rpc.publicnode.com):

- Wallet proxy `0xb203e1170a30e68dc5b20aac08aa42619842c79e` (TransparentUpgradeableProxy): implementation
  `0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a` (MultiSigV1, verified), EIP-1967 admin
  `0xca30217205742ecdc440b736aa65e0d28bd823c2`.
- Wallet `getOwners()` = `0x44c341ad187d48eafb7df892f9d4411827bb9527`, `0xedf1b98a188b2d496797b14b6b28a0f3afe5bc10`,
  `0x967a529baa2dc7cec989a073ca9a81d8a80540ca`, `0x739463da605ae91de81d2fccd534623320166349`; `required()` = 3;
  `transactionCount()` = 150. All four owners have no code (EOAs); nonces 153, 0, 0, 0.
- Admin `0xca302172…` is a `MultiSigWalletWithPermit` created by the factory in the same transaction as the proxy
  (`UpgradeableMultiSignWalletFactory.create`, which passes `_immutable = true` for the admin): same four owners,
  `required()` = 3, `transactionCount()` = 0.
- Mutability (eth_call simulations): `addOwner(0x…dEaD)` from the wallet itself succeeds (owners mutable,
  `ownersImmutable = false`); the same call from the admin to itself reverts `MS01` (admin owners immutable).

Verified source (Sourcify, `MultiSigV1.sol`):

- `executeTxWithPermits(destination, value, data, nonce, rs, ss, vs)`: `msg.sender` must be an owner; each
  `(v, r, s)` is `ecrecover`ed over an EIP-712 digest and must be an owner (lines 1359–1364); needs
  `rs.length + 1 == required`.
- Gnosis `MultiSigWallet` base: `submitTransaction` / `confirmTransaction` / `executeTransaction` by `msg.sender`
  (owners may be contracts). `addOwner`, `removeOwner`, `replaceOwner`, `changeRequirement` are `onlyWallet` and
  `notImmutable`.
- Proxy admin powers (OpenZeppelin TransparentUpgradeableProxy): `upgradeTo`, `upgradeToAndCall`, `changeAdmin`.

Recent use: `executeTxWithPermits` by `0x44c341ad…` on 2026-11-16 (USDT transfers); daily inbound transfers from
many addresses. Operator not identified (creator is the factory `0x63edeb9a…`; no explorer tags).
