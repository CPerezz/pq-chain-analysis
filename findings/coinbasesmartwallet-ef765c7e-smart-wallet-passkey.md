---
id: coinbasesmartwallet-ef765c7e-smart-wallet-passkey
format: 2
title: Coinbase Smart Wallet accepts passkeys a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Any single owner's passkey signature authorizes everything; owners must add a post-quantum signer
  and drop old ones.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xef765c7e05fdb747c9d6a6f4d48e5214d52d4fbb'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code
  proxy_of: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a post-quantum signer as an owner, then remove every passkey and ECDSA owner.
evidence_level: source
checks:
- id: c1
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  line: 313
  has: return SignatureCheckerLib.isValidSignatureNow(owner, hash, sigWrapper.signatureData);
  says: Address owners are checked via SignatureCheckerLib.
  for:
  - what
- id: c3
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: lib/webauthn-sol/src/WebAuthn.sol
  line: 162
  has: return FCL_ecdsa.ecdsa_verify(messageHash, webAuthnAuth.r, webAuthnAuth.s, x, y);
  says: WebAuthn falls back to P-256 ECDSA verification.
  for:
  - evidence-2
  - what
- id: s-p256
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: 'return WebAuthn.verify({challenge: abi.encode(hash), requireUV: false, webAuthnAuth: auth, x: x, y: y});'
  line: 321
  says: Passkey owners are verified with WebAuthn P-256.
  for:
  - evidence-1
  - justification
  - what
- id: s-upg
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 331
  says: Any owner can upgrade the wallet.
  for:
  - evidence-3
  - justification
  - what
- id: s-addaddr
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.addOwnerAddress.selector
  line: 263
  says: The wallet exposes owner add/remove functions.
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

This wallet accepts a signature from any one of its owners; a 64-byte owner is a P-256 passkey verified by WebAuthn, a 32-byte owner an address. A quantum attacker who derives an owner's private key from its public key signs operations that move funds or upgrade the wallet.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) checks a passkey owner's signature with WebAuthn.verify.
- [WebAuthn.verify](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) falls back to a P-256 ECDSA check against the stored key.
- [_authorizeUpgrade](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) lets any single owner upgrade the wallet.

## Reviewer notes

### Mechanism

validateUserOp (line 170) and ERC-1271 isValidSignature call _isValidSignature (lines 297-325). The signature names an ownerIndex. A 32-byte owner goes to solady SignatureCheckerLib.isValidSignatureNow (line 313), which tries ecrecover first. A 64-byte owner is a P-256 key (x, y) passed to WebAuthn.verify (line 321). That function tries precompile 0x100 and falls back to FCL_ecdsa.ecdsa_verify (WebAuthn.sol line 162). Any single owner authorizes the operation. _authorizeUpgrade is onlyOwner (line 331). canSkipChainIdValidation (lines 260-271) lets owner changes and upgradeToAndCall replay across chains. Recovering one P-256 or secp256k1 private key therefore gives full control of the wallet.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin exists; only the wallet's owners can change owners or upgrade.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
