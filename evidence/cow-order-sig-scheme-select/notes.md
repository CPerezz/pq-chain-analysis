# Review notes: cow-order-sig-scheme-select (2026-11-17, Review18)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454:

- `GPv2Settlement(0x9008d19f…).vaultRelayer()` = `0xc92e8bdf79f0507f65a392b0ab4667716bfe0110` (GPv2VaultRelayer)
- `GPv2Settlement.authenticator()` = `0x2c4c28ddbdac9c5e7055b4c863b72ea0149d8afe` (GPv2AllowListAuthentication, proxy)
  - EIP-1967 admin slot = `0xca771eda0c70aa7d053ab1b25004559b918fe662` (Safe, threshold 3 of 5 owners; CoW DAO)
  - EIP-1967 implementation slot = `0x9e7ae8bdba9aa346739792d219a808884996db67`
  - `manager()` = `0xa03be496e67ec29bc62f01a428683d7f9c204930` (Safe, threshold 4 of 12 owners)
- GPv2Settlement itself: no proxy (runtime code, no EIP-1967 slots per `onchain.json` at block 26,431,214).

Source (Sourcify full match, `src/contracts/mixins/GPv2Signing.sol`):

- `recoverOrderSigner` (line 141): branches on `signingScheme` chosen per trade by the order owner:
  `Eip712` → `recoverEip712Signer` → `ecdsaRecover` (`ecrecover`, line 198); `EthSign` → `recoverEthsignSigner`
  → `ecdsaRecover`; `Eip1271` → `recoverEip1271Signer` (owner encoded in the first 20 bytes, full signature passed to
  `isValidSignature`, line 294); `PreSign` → `recoverPreSigner` (`preSignature[orderUid]` set on-chain by the owner via
  `setPreSignature`, line 81).
- `GPv2Settlement.settle` (line 121, `onlySolver`) → `computeTradeExecutions` → `recoverOrderFromTrade`, then
  `vaultRelayer.transferFromAccounts(inTransfers)` (line 134) pulls the sell token from the recovered owner using the
  owner's ERC-20 allowance to GPv2VaultRelayer (or Balancer Vault relayer approval / internal balance).
- An ECDSA-scheme order's owner is whatever `ecrecover` returns; account code is never consulted, so an EOA that
  delegates to post-quantum code (EIP-7702) or otherwise stops using its key stays forgeable here.

Yearly pre-quantum calls (`data/report/curated_contracts.csv`): `txs_y1` 1,304,431 ecrecover calls.

Settlement holdings in `onchain.json` (USD 455k, 97% TRU) are the protocol's own buffers, not user funds released
by a forged order signature; not the exposure.
