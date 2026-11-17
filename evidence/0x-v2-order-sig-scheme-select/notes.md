# Review notes (Review08, 2026-11-17)

Reads at block 26,431,454 (publicnode; the draft's block 26,431,214 is past the node's non-archive window).

Source: Sourcify full match, `Exchange.sol` (single flattened file), `MixinSignatureValidator.isValidSignature(bytes32,address,bytes)`
at lines 2521-2654: the last signature byte selects the type; `EIP712` (2) and `EthSign` (3) call `ecrecover` for any
`signerAddress`, with no code check; `Wallet` (4) staticcalls `isValidSignature(bytes32,bytes)` on the signer and expects
the 0x-specific magic `0xb0671381` (not the ERC-1271 `0x1626ba7e`); `Validator` (5) needs a prior
`setSignatureValidatorApproval` by the signer; `PreSigned` (6) needs a prior `preSign`.
Callers: `fillOrder` path (line 1611, maker signature on first fill) and `executeTransaction` (line 4092, any signer,
used for taker fills and cancels on behalf of the signer).

| Call | Result |
|---|---|
| `Exchange.owner()` | `0x7d3455421bbc5ed534a83c88fd80387dc8271392` (Blockscout name `ZeroExGovernor`) |
| `getAssetProxy(0xf47261b0)` ERC20 | `0x95e6f48254609a6ee006f7d493c8e5fb97094cef` |
| `getAssetProxy(0x02571792)` ERC721 | `0xefc70a1b18c432bdc64b596838b4d138f6bc6cad` |
| `getAssetProxy(0x94cfcdd7)` MultiAsset | `0xef701d5389ae74503d633396c4d654eabedc9d78` |
| `getAssetProxy(0xa7cb5fb7)` ERC1155 | `0x7eefbd48fd63d441ec7435d024ec7c5131019add` |
| ERC20Proxy `getAuthorizedAddresses()` | v2.1 Exchange `0x080bf510…`, MultiAssetProxy `0xef701d53…`, v3 Exchange `0x61935cbd…`, ZrxVault `0xba7f8b5f…` |
| ERC721/ERC1155 proxies `getAuthorizedAddresses()` | include `0x080bf510…` |
| every asset proxy `owner()` | `0x7d3455421bbc5ed534a83c88fd80387dc8271392` |
| `0x7d3455…` `getOwners()` / `required()` / `secondsTimeLocked()` | 4 owners (`0x257619b7…`, `0x5ee2a00f…`, `0xa2d6e86e…`, `0x269984c9…`), 2 required, 1,209,600 s default time lock |
| Exchange ETH/token balance | 0 (onchain.json, block 26,431,214) |
