# Review notes (Review23, 2026-11-17)

Reads at block 26,431,426 (https://ethereum-rpc.publicnode.com):

- `Aori(0x0736bdc975af0675b9a045384efed91360d25479).owner()` = `0x941327e206b8d8cfe1014a8a95b05e1536dfd00d`
- `cast code 0x941327e2…` = `0x` (EOA, nonce 514)
- `paused()` = false
- EIP-1967 implementation slot = 0 (not a proxy)

Verified source (Sourcify, `contracts/Aori.sol`, `contracts/AoriUtils.sol`):

- `deposit(Order, bytes signature)` and `deposit(Order, bytes, SrcHook)`: `onlySolver`, `whenNotPaused`;
  `AoriUtils.validateDeposit` -> `ECDSA.recover(digest, signature) == order.offerer` (solady, no ERC-1271), then
  `safeTransferFrom(order.offerer, address(this), order.inputAmount)`.
- `depositNative(Order)`: `msg.sender == order.offerer`, no signature (native ETH only).
- Owner-only: `pause`, `add/removeAllowedSolver`, `add/removeAllowedHook`, `add/removeSupportedChain`,
  `emergencyCancel`, `emergencyWithdraw` (two overloads). No upgrade function, no proxy.

Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` = 25,538, `usd_tx_y1` = 86,753,915.

## Older and paused deployments (merged 2026-11-17)

Attribution and selector match by Review13: [`attribution-older-deployments.json`](attribution-older-deployments.json)
(block 26,431,618). Reads by Review23 at block 26,431,716:

| Contract | owner() | paused() | ETH | priced tokens | last ecrecover use |
|---|---|---|---|---|---|
| 0x7dec965cf240f81299683f48a18ebdbe8b2accb5 (unverified) | 0xb4afac16… (EOA) | false | 0 | $0 | block 22,953,387 (2025-07-19) |
| 0xbb4c20cb237f3629d1afc3ecb3e84148fa426c12 (unverified) | 0xb4afac16… | false | 0 | $0 | block 22,421,870 (2025-05-06) |
| 0x8635c874b0fcb361fb9a2f5218852d4b7fc5ace3 (verified Aori) | 0xb4afac16… | true | 0 | $0.02 | block 24,677,597 (2026-03-17) |

- `0x8635c874…` verified source (Sourcify, `contracts/AoriUtils.sol` lines 58–60): same
  `ECDSA.recover(digest, signature) == order.offerer` check as `0x0736bdc9…`. Its last transactions (Blockscout) are
  the owner's `emergencyWithdraw` (x2) and `pause` on 2026-08-19; none since.
- Yearly pre-quantum use (`curated_contracts.csv`, `txs_y1`): `0x7dec965c…` 29,535; `0xbb4c20cb…` 22,508;
  `0x8635c874…` 6,491 (from attribution.json; not in curated_contracts.csv).
