# Review notes: unidentified-3762a79b-signer-key (2026-11-17, Review18)

## Identity

- Proxy `0x3762a79b…` is a verified OpenZeppelin `TransparentUpgradeableProxy` (Sourcify exact match). The verified
  build includes unrelated project files (an "Eventum" ERC721/vault project and copied InceptionLRT bridge code);
  they are not the implementation and say nothing about the operator.
- Deployed in tx `0xd59a0da7…` (block 20,719,196) by EOA `0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c` (Sourcify
  deployment record). The same EOA deployed VerifyingPaymaster `0x1c6ad754…` (finding
  `unidentified-1c6ad754-signer-key`) and its sibling paymasters, per that finding's notes.
- Implementation `0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5`: unverified (Sourcify, Blockscout); created by EOA
  `0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9`.
- `eip712Domain()` = name "LiquidityBank", version "1", chain 1, verifying contract = the proxy.
- No ENS, tag or source attribution found for any of these EOAs: project still unidentified.

## Bytecode (implementation, 14,556 bytes)

- Dispatcher selectors: `getVerifyingSigner()`, `PAYMASTER()`, `ENTRY_POINT_ADDRESS()`, `eip712Domain()`,
  `initialize(address,address)`, `setPaused()`, `setUnpaused()`, `paused()`, `owner()`, `transferOwnership`,
  `renounceOwnership`, `0xb460af94` (= `withdraw(uint256,address,address)`), and 9 unresolved selectors
  (`05b1737e`, `101916e0`, `354d2a25`, `65bd4f0e`, `863d51c9`, `a0897609`, `b695c935`, `c617b667`, `f1db4763`).
- Revert strings: "Invalid deposit order", "Order token info required", "Unsupported token", "Incorrect ETH amount",
  "Order locked", "Order expired", "Order already processed", "Order already released", "Order already refunded",
  "Invalid release order", "Invalid refund order", "Invalid refund sender", "Origin not whitelisted",
  "Order not found in deposit record", "LiquidityBank: invalid verifying…", "Withdraw address cannot be zero".
- Contains the secp256k1 `n/2` constant (OpenZeppelin `ECDSA` malleability check) and EIP-712 code.
- INFERRED: users deposit ETH or tokens against an order (for paymaster-sponsored operations); the order, release and
  refund are authorised by an EIP-712 signature from `getVerifyingSigner()`, checked with `ecrecover`. Exact function
  per selector not established.

## On-chain reads (`cast`, https://ethereum-rpc.publicnode.com, block 26,431,733)

- EIP-1967 admin = ProxyAdmin `0x166fd12e962290250aebf178f60ff0a250e2159c`, `owner()` = EOA `0xd77dbd06…` (nonce 707).
- EIP-1967 implementation = `0xab8a2cfc…`.
- `owner()` = EOA `0x82d04d2b250c3e017fcc2e333ec043b6b9bf7c77` (set by `transferOwnership` from `0xd77dbd06…` on
  2026-04-20); `paused()` = true (`setPaused()` on 2026-04-20).
- `getVerifyingSigner()` = EOA `0x75814d0960258ea854b325049a0018027da162c7` (nonce 0: signs only off-chain).
- `PAYMASTER()` = `0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4` (unverified; `verifyingSigner()` = `0x7e416860…`,
  `owner()` = `0xbe4c70a0…`, the same signer and owner as `0x1c6ad754…`); `ENTRY_POINT_ADDRESS()` = EntryPoint v0.6
  `0x5ff137d4…`.
- ETH balance 0; priced tokens USD 0.09 (`onchain.json`, block 26,431,214).

## Activity

- Blockscout: last transactions are `withdraw` (`0xb460af94`) calls by EOA `0xdf51b037…` on 2026-04-20 and
  2026-10-09 (4 each), after the pause.
- Precompile trace (remote `data/agg`): 57,715 `ecrecover` calls in total, blocks 20,724,686–24,682,544; 49,144 calls
  in 47,243 transactions in the year to March 2026 (`txs_y1`); `usd_tx_y1` USD 16.6M of transfers in those
  transactions (`data/report/curated_contracts.csv`).
