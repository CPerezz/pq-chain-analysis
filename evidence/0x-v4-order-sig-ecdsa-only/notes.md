# Review notes (Review08, 2026-11-17)

`0xdef1c0de…` is the ZeroEx feature router; its own verified source (`ZeroEx.sol`) has no signature code, so the
excerpt file is empty. Features resolved with `getFunctionImplementation(bytes4)` at block 26,431,454:

| Selector | Function | Feature implementation (Sourcify exact match) |
|---|---|---|
| `0xf6274f66` | `fillLimitOrder` | `0x1fcc3e6f76f7a96cd2b9d09f1d3c041ca1403c57` NativeOrdersFeature |
| `0xaa77476c` | `fillRfqOrder` | `0x1fcc3e6f…` NativeOrdersFeature |
| `0xea7faa61` | `registerAllowedOrderSigner` | `0x1fcc3e6f…` NativeOrdersFeature |
| `0xdac748d4` | `fillOtcOrder` | `0x5ebac8dbfbba22168471b0f914131d1976536a25` OtcOrdersFeature |
| `0x4f948110` | `fillTakerSignedOtcOrder` | `0x5ebac8db…` OtcOrdersFeature |
| `0x3d61ed3e` | `executeMetaTransaction` | `0xf2a9f3a29fc4c70d4518f1a46227e9b0a630cae2` MetaTransactionsFeature |
| `0x415565b0` | `transformERC20` | `0x44a6999ec971cfca458aff25a808f272f6d492a2` |

Source read:
- `LibSignature.sol`: `SignatureType { ILLEGAL, INVALID, EIP712, ETHSIGN }`; `Signature { signatureType, v, r, s }`
  (fixed size); `getSignerOfHash` (lines 67-111) is `ecrecover` for EIP712 and ETHSIGN. No ERC-1271, no pre-sign.
- `NativeOrdersSettlement.sol`: `_fillLimitOrderPrivate` line 396-400 and `_fillRfqOrderPrivate` lines 503-509:
  `signer = getSignerOfHash(orderHash, signature)`; accepted if `signer == order.maker` or
  `isValidOrderSigner(order.maker, signer)`. `registerAllowedOrderSigner` (line 611) lets `msg.sender` (a maker
  contract) delegate to another address, which must itself produce an ECDSA signature.
- `OtcOrdersFeature.sol`: lines 251, 297 (`taker = getSignerOfHash(...)` for taker-signed OTC orders) and 467 (maker).
- `MetaTransactionsFeature.sol` line 340: `getSignerOfHash(state.hash, state.signature) != mtx.signer` reverts; the
  meta-transaction then fills or transforms with `mtx.signer` as taker (lines 426, 487, 516).

On-chain (block 26,431,454):

| Call | Result |
|---|---|
| ZeroEx `owner()` | `0x618f9c67ce7bf1a50afa1e7e0238422601b0ff6e` (Blockscout name `ZeroExGovernor`) |
| `0x618f9c67…` `getOwners()` | `0x5ee2a00f…`, `0x257619b7…`, `0x2b3c8b68…`, `0x269984c9…` |
| `required()` / `secondsTimeLocked()` | 2 / 172,800 s |
| ZeroEx holdings | ETH 0.00006 + about USD 2 of tokens (onchain.json, block 26,431,214): dust, not the exposure |
