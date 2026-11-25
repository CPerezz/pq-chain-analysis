---
id: coinbasesmartwallet-0b7920a4-smart-wallet-passkey
format: 2
title: Coinbase Smart Wallet lets a quantum attacker forge one owner key to drain it
status: confirmed
severity: MEDIUM
justification: Any single passkey or ECDSA owner controls the wallet; owners can fix it by adding a PQ signer and
  removing old owners.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0b7920a49953cba15f9188f6bd4c0be66421bfc0'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code
  proxy_of: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 7
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a post-quantum signer as an owner, then remove every passkey and EOA owner.
evidence_level: source
checks:
- id: c1
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  line: 334
  has: return SignatureCheckerLib.isValidSignatureNow(owner, hash, sigWrapper.signatureData);
  says: address owners go through SignatureCheckerLib.isValidSignatureNow
  for:
  - evidence-2
  - what
- id: c3
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: lib/webauthn-sol/src/WebAuthn.sol
  line: 162
  has: return FCL_ecdsa.ecdsa_verify(messageHash, webAuthnAuth.r, webAuthnAuth.s, x, y);
  says: P-256 fallback verification via FreshCryptoLib ECDSA
  for:
  - what
- id: s-validate
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (_isValidSignature(userOpHash, userOp.signature)) {
  line: 191
  says: validateUserOp accepts a userOp when _isValidSignature passes
  for:
  - what
- id: s-ownerlen32
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (ownerBytes.length == 32) {
  line: 322
  says: 32-byte owners are treated as addresses
  for:
  - action
  - evidence-2
  - justification
- id: s-ownerlen64
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (ownerBytes.length == 64) {
  line: 337
  says: 64-byte owners are treated as P-256 public keys
  for:
  - evidence-1
  - justification
- id: s-webauthn
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: 'return WebAuthn.verify({challenge: abi.encode(hash), requireUV: false, webAuthnAuth: auth, x: x, y: y});'
  line: 342
  says: passkey owners are verified with P-256 WebAuthn
  for:
  - evidence-1
  - what
- id: s-authup
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 352
  says: any single owner can authorize an upgrade
  for:
  - evidence-3
  - justification
  - what
- id: s-addowner
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.addOwnerAddress.selector
  line: 284
  says: the wallet supports adding address owners
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-9
reviews: []
related: []
---

## What happens

This wallet accepts a user operation or ERC-1271 signature from any one owner, checked as a P-256 passkey via WebAuthn or as an address via ecrecover-first signature checking. A quantum attacker who recovers one owner's private key signs as that owner and moves funds or upgrades the wallet.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks a 64-byte owner as a P-256 key with WebAuthn.verify.
- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks a 32-byte address owner with SignatureCheckerLib.isValidSignatureNow.
- [_authorizeUpgrade](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) lets any owner upgrade the wallet.

## Reviewer notes

### Mechanism

validateUserOp (line 191) calls _isValidSignature (lines 318-346), which decodes a SignatureWrapper and loads ownerAtIndex(ownerIndex). A 32-byte owner is verified with SignatureCheckerLib.isValidSignatureNow (line 334), which tries ecrecover for 64/65-byte signatures before ERC-1271. A 64-byte owner is a P-256 key verified with WebAuthn.verify (line 342), using precompile 0x100 and FreshCryptoLib ecdsa_verify as fallback (WebAuthn.sol line 162). execute/executeBatch are onlyEntryPointOrOwner, and _authorizeUpgrade is onlyOwner (line 352). Owner changes and upgradeToAndCall are allowed in executeWithoutChainIdValidation (canSkipChainIdValidation, lines 281-292), so one forged signature can be replayed across chains.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin exists; each wallet's owners act.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
