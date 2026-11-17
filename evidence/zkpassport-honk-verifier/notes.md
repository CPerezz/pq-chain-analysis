# Review notes (Review08, 2026-11-17)

Reads at block 26,431,581 unless noted.

Attribution: Blockscout creator of `0x8198cd50…` is `0x9cf1e6240f7e38c95eef14707395f5366687b502`, which on 2025-11-09
deployed `ZKPassportSubVerifier` `0xc1fb0d750a95fb95d5bcc585b17f8fab62681bf8`, `ZKPassportHelper`, two `CircuitRegistry`,
a `CertificateRegistry` and ten `HonkVerifier`s (this one among them), then transferred their admin to
`0x2000ab040a899f914d6dfd2457c3dfbb22d4c762`.

Registry (verified source on Blockscout, `src/ZKPassportSubVerifier.sol`, `src/ZKPassportRootVerifier.sol`):
- `ZKPassportSubVerifier.proofVerifiers(bytes32 vkeyHash) -> address`; `addProofVerifiers` / `removeProofVerifiers`
  `onlyAdmin`; `verify` (line 237) calls `IProofVerifier(verifier).verify(proof, publicInputs)`.
- `ZKPassportRootVerifier.subverifiers(bytes32 version)`; `addSubVerifier` / `removeSubVerifier` / `updateSubVerifier`
  `onlyAdmin`.

| Call / log | Result |
|---|---|
| sub-verifier `ProofVerifierAdded` (block 23,762,003) | `0x8198cd50…` for vkeyHash `0x17407da3db9149eea7c0a22ae09777c7408da8ad31e7aa7e689a224d84c6fbef` |
| `proofVerifiers(0x17407da3…)` | `0x8198cd50…` (still mapped) |
| sub-verifier `admin()` / `paused()` / `rootVerifier()` | `0x2000ab04…` / false / `0x1d000001000efd9a6371f4d90bb8920d5431c0d8` |
| root `admin()` / `guardian()` / `subverifierCount()` | `0x2000ab04…` / zero / 12 |
| root `SubVerifierAdded` | `0xc1fb0d75…` for versions `0x0000000f0001`, `0x00000010`, `0x000000110001`; newer versions use other sub-verifiers (latest `0x00000016` -> `0x4507fe85…`, block 26,386,077) |
| `0x2000ab04…` `getThreshold()` / `getOwners()` | 1 / `0xcccf3b4d…`, `0x346bf08c…` (Safe) |

Consumer: all 3,977 transactions with this verifier's pairing calls fall in blocks 23,790,488-23,955,308
(`data/agg/y1_tx_caller.parquet`); 6 random ones were all `mint` on Aztec's `IgnitionParticipantSoulbound`
`0xbf3cf56c587f5e833337200536a52e171ef29a09`, identity provider `ZKPassportProvider`
`0xe4f80f2597fa53bf5adb013ae1e1eb1de4fef479`.

| Call | Result |
|---|---|
| soulbound `identityProviders(0xe4f80f25…)` | true |
| soulbound `owner()` | `0x81a62d779d696fed5893e043fd5eb95e5ad887a1` (Safe, 3 of 5) |
| soulbound `tokenSaleAddress()` | `0xbe88a980765844e6b9493b7733ac764816faf748` (`GenesisSequencerSale`) |
| sale `saleStartTime()` / `saleEndTime()` / `isSaleActive()` | 1,763,042,400 / 1,764,597,600 (2025-12-01) / false |
| ETH + priced tokens of soulbound and sale (Blockscout) | 0 / 0 |
