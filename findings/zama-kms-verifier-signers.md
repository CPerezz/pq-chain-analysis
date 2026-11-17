---
id: zama-kms-verifier-signers
title: "Zama FHEVM: a quantum attacker who recovers 7 of 13 KMS ECDSA signer keys can forge decryption results and unwrap more than was wrapped, draining at least $38.5M from Zama confidential-token wrappers"
project: zama
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x77627828a55156b04ac0dc0eb30467f1a552bb03"
  implementation: "0x390683dea46a61786f4f0807bf3559038cf43fa4"
  name: KMSVerifier (ERC1967 UUPS proxy)
  upgradeable: "yes"
  admin: "ACL owner = Aragon OSx DAO 0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3 (onlyACLOwner: upgrade; KMS signer sets and thresholds in ProtocolConfig 0xd8236b57394f90726b26ab25d38ceac776e1a7c4, also onlyACLOwner); read at block 26431457"
  value_usd: 38472577
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-17
  txs_30d: null
families: []
fix:
  layer: contract-upgrade
  who_acts: "Zama governance: the Aragon OSx DAO 0xb6d69d5f334d8b97b194617b53c6ab62f8681ef3 that owns ACL 0xca2e8f1f656cd25c01f05d0b243ab1ecd4a8ffb6 upgrades KMSVerifier (and ProtocolConfig) to post-quantum KMS signatures; the KMS nodes must sign with a post-quantum scheme"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431457
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zama-kms-verifier-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zama-kms-verifier-signers/review-reads.json
  date: 2026-11-17
  verdict: reported
  rating: MEDIUM
related: [zama-coprocessor-signers]
---

## Summary

Zama's KMSVerifier accepts a public decryption result (a cleartext claimed for encrypted handles) when at least 7 of
the 13 registered KMS signers, ECDSA keys, have signed it (PQ-5). Zama's confidential-token wrappers release
underlying tokens on `finalizeUnwrap` for whatever cleartext amount that check accepts, so a quantum attacker who
recovers 7 KMS keys can start a small unwrap and finalize it with a forged, larger amount. The wrappers found hold at
least $38.5M of priced underlying tokens, plus about 42M units of tokens without a market price. Rated MEDIUM
(step 4): the governing DAO can upgrade the verifier.

## Mechanism

- `KMSVerifier.verifyDecryptionEIP712KMSSignatures(handlesList, decryptedResult, decryptionProof)` (l.141-185): the
  proof is a signer count, 65-byte signatures and extra data selecting a KMS context; the EIP-712
  `PublicDecryptVerification` covers the handles and the cleartexts.
- `_verifySignaturesDigestForContext` (l.332-366): `ECDSA.recover` per signature (`_recoverSigner`, l.411-412), each
  must be a KMS signer of the context in ProtocolConfig `0xd8236b57…`, and at least the context's public-decryption
  threshold must be distinct.
- Consumer: `ERC7984ERC20WrapperUpgradeable.finalizeUnwrap` (l.144-166, in ConfidentialWrapper implementations
  `0x2abad220…` and `0x35e980f5…`) calls `FHE.checkSignatures(handles, abi.encode(unwrapAmountCleartext), proof)`, which
  calls this KMSVerifier (address fixed in `ZamaConfig.sol` l.82-88), then transfers
  `unwrapAmountCleartext * rate()` of the underlying token to the requester.
- KMSVerifier `_authorizeUpgrade` (l.371) and ProtocolConfig `defineNewKmsContext` / `destroyKmsContext` / threshold
  updates and upgrade (l.139-163, l.425) are `onlyACLOwner`.

Pattern PQ-5. Source and lines: [`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/zama-kms-verifier-signers/review-reads.json).

## Evidence

- CHECKED (Sourcify verified source of KMSVerifier `0x390683de…`, ProtocolConfig `0x25c76298…` and ConfidentialWrapper
  `0x2abad220…` / `0x35e980f5…`, read 2026-11-17): the functions above.
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0x390683de…` (`getVersion()` "KMSVerifier v0.3.0");
  `getKmsSigners()` 13 addresses; `getThreshold()` 7; ACL `owner()` = `0xb6d69d5f…` (ERC-1967 proxy to an Aragon OSx
  `DAO` implementation).
- CHECKED (on-chain at block 26,431,457; prices from Blockscout on 2026-11-17): `underlying()`, `owner()` and the
  underlying balance of 25 ERC-7984 "Confidential …" wrappers found through Blockscout search; 24 are owned by the DAO
  `0xb6d69d5f…`, cKAIO by `0xf9fe4f72…`.
- CHECKED (Blockscout internal transactions): KMSVerifier was called on 2026-11-17 by wrapper proxies and FHEVM NFT
  collections. The 30-day and yearly counts were not measured (the contract was not in the census).
- INFERRED: the wrapper list from token search is not exhaustive; cKAIO's implementation `0x194b5cb2…` is not on
  Sourcify (Blockscout names it ConfidentialWrapper).

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x77627828…` KMSVerifier (ERC1967 UUPS proxy) | yes | $38.5M (wrappers) | 2026-11-17 | not measured |

Wrapper escrows (underlying held at block 26,431,457):

| Wrapper | Underlying | Held | USD |
|---|---|---|---|
| `0x66bf74e9…` csteakcUSDC | STEAKCUSDC | 21,107,732.15 | $21,783,180 |
| `0x80cb147f…` cZAMA | ZAMA | 128,041,486.45 | $7,279,030 |
| `0xae0207c7…` cUSDT | USDT | 6,099,162.04 | $6,094,856 |
| `0xe978f221…` cUSDC | USDC | 1,676,503.50 | $1,675,870 |
| `0x4fccf804…` croxUSDCy | ROXUSDCY | 851,880.19 | $871,473 |
| `0x1f6a9371…` csteakUSDT | STEAKUSDT | 435,301.56 | $448,796 |
| `0xd86ae89c…` cWBTC | WBTC | 1.82 | $117,480 |
| 14 smaller wrappers | various | — | $201,892 |
| `0xa28a369d…` cfcUSDT | FCUSDT | 22,999,151.80 | no price |
| `0x85de671c…` cBRON | BRON | 10,210,824.84 | no price |
| `0xb1b18ad1…` croxcUSDC | ROXCUSDC | 9,010,557.91 | no price |
| `0xf921a5b0…` carmcWBTC | ARMCWBTC | 86.23 | no price |

The `value_usd` is the priced total ($38,472,577); the unpriced wrappers (mostly USD vault shares) would add
roughly $32M more if valued near $1 per share (INFERRED). Other FHEVM applications that rely on public decryptions
(for example NFT reveals) were not measured.

## Remediation

- Zama governance (DAO `0xb6d69d5f…`): upgrade KMSVerifier to verify post-quantum KMS signatures (ML-DSA or
  hash-based, or one succinct proof over them), with the KMS nodes signing under that scheme. `defineNewKmsContext`
  only rotates ECDSA keys.
- Wrapper owners (the same DAO for 24 of 25) can pause wrappers if the upgrade is not ready.
- Holders of confidential tokens: unwrap to the underlying token if the verifier has not been upgraded.
- Protocol change: not needed.

## History

- 2026-11-17: created in review (Review09), from verified source and on-chain reads at block 26,431,457; found while reviewing `zama-coprocessor-signers`. Rated MEDIUM (step 4: upgrade by the governing DAO; escrow at least $38.5M, so step 5 does not lower it).
