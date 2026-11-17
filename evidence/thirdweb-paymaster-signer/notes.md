# Review reads: thirdweb-paymaster-signer (2026-11-17, Review07)

Split from `pimlico-paymaster-signer` (see that finding's `evidence/pimlico-paymaster-signer/notes.md` for the shared
reads below).

## Operator (INFERRED thirdweb)

- Both contracts were deployed 2025-06-18 through the CREATE2 factory `0x4e59b448…956c` by
  `0xdaabdaac8073a7dabdc96f6909e8476ab4001b34`, ENS `0xfirekeeper.eth` (Blockscout). "0xfirekeeper" publishes the
  thirdweb .NET SDK on NuGet (`nuget.org/profiles/0xfirekeeper`, package `Thirdweb`) and contributes to
  `thirdweb-dev/js`.
- `TransactionSponsored(bytes32 identifier, bytes extraData)` events of `0x6442f472…` (Blockscout logs, latest 50,
  blocks up to 26,426,173): `extraData` decodes to ASCII `team_cll5mvyyt0kwx3n0um7zjdxoh-prj_clv08989h02jr86q694h8b795`
  (36) and `team_cmae0fozm01yd9s0kev4pt4fs-prj_cmbs7e55n00ay760k5nk1aryt` (14): thirdweb dashboard team and project
  identifiers.
- Not found: a thirdweb document listing these addresses.

## Source

- `ShieldedVerifyingPaymasterV6` `0x6442f4729ee8c890d310ef92845d43184a12ee6a` (Sourcify,
  `src/paymaster/ShieldedVerifyingPaymasterV6.sol`): `_validatePaymasterUserOp` → `bundler allowlist check`, then
  `ECDSA.recover(SignatureCheckerLib.toEthSignedMessageHash(getHash(userOp)), signature)`; valid iff
  `signers[recovered]`; `_parseVerifyingConfig` rejects signatures that are not 64 or 65 bytes. `BasePaymasterV6`:
  `Ownable`, `MultiSigner`. `_postOp` emits `TransactionSponsored(userOpHash, extraData)`.
- `ShieldedVerifyingPaymasterV7` `0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab`: Blockscout-verified, same structure
  for EntryPoint v0.7 (not on Sourcify).

## On-chain reads

- `cast` at block 26,431,569: `owner()` = `0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01` (no code) on both;
  `signers(0x2454266295e8e25f46b2c5c8016eb21da43af86f)` = true on both (that signer address has nonce 0).
- Constructor args (Blockscout): owner `0x13317c81…bb29`, signers `[0x2454…86f]`; `0x13317c81…` transferred ownership
  to `0x6dd80d80…` on 2026-08-11; `0x6dd80d80…` last changed the bundler allowlists on 2026-11-11.
- EntryPoint deposits (`balanceOf`, block 26,431,527, ETH $1,811.62): `0x6442…` 0.09735 ETH on v0.6
  `0x5ff137d4…2789` ($176); `0x5fa6…` 0.13998 ETH on v0.7 `0x00000000…a032` ($254).
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 195,023 (V6) and 35,243 (V7).
