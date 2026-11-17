# Owner reads (Review12, 2026-11-17)

`cast` against https://eth.drpc.org at block 26,431,561: EIP-1967 implementation slot, `nextOwnerIndex()`,
`ownerCount()`, `ownerAtIndex(i)` (64 bytes = P-256 public key (x, y); 32 bytes = address owner), and `eth_getCode` of
address owners (latest block).

| Wallet | Implementation | Owners |
|---|---|---|
| 0x1631adb3e1fdb65e7936272c89861cb2aac2906a | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x6d0738b778dd5fff419da8ed5d6e6add3b6c12e2 (EOA) |
| 0xef765c7e05fdb747c9d6a6f4d48e5214d52d4fbb | 0x000100abaad02f1cfc8bbe32bd5a564817339e72 | [0] passkey |
| 0x0b7920a49953cba15f9188f6bd4c0be66421bfc0 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0xff814427528f33a2165305f6d8db30dd1bd8ba4e (EOA) |
| 0x3aa9add3f321db2a99bf394f75b6def1cd47fc80 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x21df70d85ef9af19c3ee797500b3d1423f634036 (EOA) |
| 0x2ea269e0102e70817be5929662e47ee7a0980b95 | 0x00000110dcdedc9581cb5ecb8467282f2926534d | [0] passkey; [1] 0x221a9de3d666bdac71d0e6fa4c5ff6587136606a (EOA); [2] 0x4de99b804bda114135e4dba5780f86a08e87dbc1 (EOA) |
| 0xea03aa1a0e629c171c9681deba61aae72aa1ed1a | 0x000100abaad02f1cfc8bbe32bd5a564817339e72 | [0] passkey; [1] 0xf85210b21cc50302f477ba56686d2019dc9b67ad (contract) |

Source (Sourcify, implementation 0x000100ab…; the 0x00000110… excerpt has the same `_isValidSignature`):
- `CoinbaseSmartWallet._isValidSignature` (lines 297–325): 32-byte owner → solady
  `SignatureCheckerLib.isValidSignatureNow` (ecrecover first for 64/65-byte signatures, then ERC-1271 with the full
  signature); 64-byte owner → `WebAuthn.verify` (P-256 via precompile 0x100, FreshCryptoLib fallback).
- `_authorizeUpgrade` is `onlyOwner` (line 331); `MultiOwnable.onlyOwner` (line 93) accepts any single owner or the
  wallet itself; `addOwnerAddress`, `addOwnerPublicKey`, `removeOwnerAtIndex`, `removeLastOwner`, `upgradeToAndCall`
  may be replayed across chains (`canSkipChainIdValidation`, lines 260–271).
