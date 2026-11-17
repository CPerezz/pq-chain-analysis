# Review notes (Review23, 2026-11-17)

Reads at block 26,431,426 (https://ethereum-rpc.publicnode.com):

- Proxy `0x000000000000c9b3e2c3ec88b1b4c0cd853f4321`: EIP-1967 implementation slot =
  `0xc96ca8f090b7ef89c8ec43a50ac802a22935e99b` (PendleLimitRouter); admin slot = `0xa28c08f165116587d4f3e708743b4dee155c5e64`.
- ProxyAdmin `0xa28c08f1…`.owner() = Safe `0x8119ec16f0573b7dac7c0cb94eb504fb32456ee1` (threshold 3; 5 owners per onchain.json).
- Router `owner()` = `0x2ad631f72fb16d91c4953a7f4260a97c2fe2f31e`: ERC1967Proxy -> PendleGovernanceProxy
  (`0x53c26f76…`, Blockscout name); `hasRole(DEFAULT_ADMIN_ROLE, 0x8119ec16…)` = true.
- `mintSySigner1()` = `mintSySigner2()` = `0x0000000000000000000000000000000000000000` (mintSy option disabled: no
  signature can verify for address 0).
- `feeRecipient()` = `0x8270400d528c34e1596ef367eedec99080a1b592`.

Verified source (Sourcify, implementation `0xc96ca8f0…`):

- `LimitRouterBase._checkSig`: `SignatureChecker.isValidSignatureNow(order.maker, orderHash, signature)` for orders
  not pre-signed; OpenZeppelin SignatureChecker v4.9.0 = `ECDSA.tryRecover` first, then ERC-1271.
- `_transferFromMakers_mintSy_updMakings` -> `_transferIn(order.token, order.maker, makingAmount)` pulls maker tokens.
- `PendleLimitRouter.preSignSingle/preSignBatch`: `order.maker == msg.sender`, sets remaining so `fill` skips the
  signature check. `cancelSingle/cancelBatch` by maker; owner `forceCancel`.
- `MintSyHelper._verifyMintSyData`: two operator signatures (`mintSySigner1/2`) over swap data; result bounded per
  order by `failSafeRate`.

Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` = 29,490; `usd_tx_y1` = 7,142,508,889.
