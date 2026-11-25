---
id: coinbasesmartwallet-ea03aa1a-smart-wallet-passkey
format: 2
title: 'Coinbase Smart Wallet: a quantum attacker can forge one owner to take it over'
status: confirmed
severity: MEDIUM
justification: Any single passkey or ECDSA owner controls the wallet; owners can fix it by adding a post-quantum
  signer, so MEDIUM.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xea03aa1a0e629c171c9681deba61aae72aa1ed1a'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code
  proxy_of: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: funds-loss
action: Add a post-quantum signer as an owner, then remove every passkey and ECDSA address owner.
evidence_level: source
checks:
- id: c1
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  line: 313
  has: return SignatureCheckerLib.isValidSignatureNow(owner, hash, sigWrapper.signatureData);
  says: Address owners are checked with SignatureCheckerLib (ECDSA recovery first).
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: lib/webauthn-sol/src/WebAuthn.sol
  line: 162
  has: return FCL_ecdsa.ecdsa_verify(messageHash, webAuthnAuth.r, webAuthnAuth.s, x, y);
  says: P-256 verification falls back to FreshCryptoLib ECDSA.
  for:
  - what
- id: s-index
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: bytes memory ownerBytes = ownerAtIndex(sigWrapper.ownerIndex);
  line: 299
  says: the line or bytes the card cites
  for:
  - justification
  - what
- id: s-p256
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: 'return WebAuthn.verify({challenge: abi.encode(hash), requireUV: false, webAuthnAuth: auth, x: x, y: y});'
  line: 321
  says: the line or bytes the card cites
  for:
  - evidence-1
  - justification
  - what
- id: s-uop
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: if (_isValidSignature(userOpHash, userOp.signature)) {
  line: 170
  says: the line or bytes the card cites
  for:
  - what
- id: s-upgrade
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 331
  says: the line or bytes the card cites
  for:
  - evidence-3
  - justification
  - what
- id: s-skip-add
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.addOwnerAddress.selector
  line: 263
  says: the line or bytes the card cites
  for:
  - action
- id: s-skip-remove
  source: '0x000100abaad02f1cfc8bbe32bd5a564817339e72'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.removeOwnerAtIndex.selector
  line: 264
  says: the line or bytes the card cites
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

This smart wallet accepts a signature from any one of its owners, checking a P-256 passkey with WebAuthn or an owner address through ECDSA recovery. A quantum attacker who derives one owner's private key from its public key can sign operations that move funds or upgrade the wallet.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) checks a 64-byte owner with WebAuthn.verify over P-256.
- [_isValidSignature](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) checks an address owner with SignatureCheckerLib.isValidSignatureNow.
- [_authorizeUpgrade](https://etherscan.io/address/0x000100abaad02f1cfc8bbe32bd5a564817339e72#code) needs only onlyOwner, so one owner can replace the code.

## Reviewer notes

### Mechanism

validateUserOp (line 149) calls _isValidSignature(userOpHash, userOp.signature) at line 170. _isValidSignature (lines 297-325) decodes a SignatureWrapper, loads ownerAtIndex(ownerIndex); a 32-byte owner goes to SignatureCheckerLib.isValidSignatureNow (line 313, ecrecover first for 64/65-byte signatures), a 64-byte owner is a P-256 key verified by WebAuthn.verify (line 321), which uses precompile 0x100 and falls back to FreshCryptoLib ecdsa_verify (WebAuthn.sol line 162). _authorizeUpgrade (line 331) is onlyOwner, so upgradeToAndCall is reachable by one owner signature; canSkipChainIdValidation (lines 260-271) lets owner changes and upgrades be replayed across chains.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin; each wallet's owners control it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
