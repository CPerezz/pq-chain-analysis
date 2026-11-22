---
id: coinbasesmartwallet-3aa9add3-smart-wallet-passkey
format: 2
title: Coinbase Smart Wallet lets a quantum attacker forge one owner key to drain it
status: confirmed
severity: MEDIUM
justification: Any single passkey or ECDSA owner controls the wallet; owners can fix it by adding a post-quantum
  signer.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3aa9add3f321db2a99bf394f75b6def1cd47fc80'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code
  proxy_of: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 12
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a post-quantum signer as an owner, then remove every passkey and ECDSA owner from the wallet.
evidence_level: source
checks:
- id: c1
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  line: 334
  has: return SignatureCheckerLib.isValidSignatureNow(owner, hash, sigWrapper.signatureData);
  says: address owners are checked with SignatureCheckerLib (ecrecover first)
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: lib/webauthn-sol/src/WebAuthn.sol
  line: 162
  has: return FCL_ecdsa.ecdsa_verify(messageHash, webAuthnAuth.r, webAuthnAuth.s, x, y);
  says: WebAuthn falls back to FreshCryptoLib P-256 ECDSA verification
  for:
  - evidence-1
  - what
- id: s-validate
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (_isValidSignature(userOpHash, userOp.signature)) {
  line: 191
  says: the line or bytes the card cites
  for:
  - what
- id: s-wrapper
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: bytes memory ownerBytes = ownerAtIndex(sigWrapper.ownerIndex);
  line: 320
  says: the line or bytes the card cites
  for:
  - what
- id: s-p256
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: 'return WebAuthn.verify({challenge: abi.encode(hash), requireUV: false, webAuthnAuth: auth, x: x, y: y});'
  line: 342
  says: the line or bytes the card cites
  for:
  - evidence-1
  - justification
  - what
- id: s-execute
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: onlyEntryPointOrOwner
  line: 232
  says: the line or bytes the card cites
  for:
  - what
- id: s-upgrade
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 352
  says: the line or bytes the card cites
  for:
  - evidence-3
  - justification
  - what
- id: s-skip-add
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.addOwnerAddress.selector
  line: 284
  says: the line or bytes the card cites
  for:
  - action
- id: s-skip-remove
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.removeOwnerAtIndex.selector
  line: 285
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
reviews: []
related: []
---

## What happens

The wallet accepts a signature from any one of its owners. Passkey owners are checked with P-256 WebAuthn, address owners with ECDSA recovery. A quantum attacker who derives one owner's key can move funds or upgrade the wallet.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) verifies a passkey owner's signature with WebAuthn over P-256.
- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks an address owner with SignatureCheckerLib.isValidSignatureNow.
- [_authorizeUpgrade](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) requires only onlyOwner, so any one owner can upgrade the wallet.

## Reviewer notes

### Mechanism

validateUserOp (line 154) calls _isValidSignature (line 191, line 318). That function decodes a SignatureWrapper and reads ownerAtIndex(ownerIndex) at line 320. For a 32-byte owner, line 334 calls SignatureCheckerLib.isValidSignatureNow, which tries ecrecover first. For a 64-byte owner, line 342 calls WebAuthn.verify. That function tries the P-256 precompile at 0x100 (WebAuthn line 153) and falls back to FCL_ecdsa.ecdsa_verify (line 162). One valid owner signature authorizes execute/executeBatch through the EntryPoint. _authorizeUpgrade (line 352) is onlyOwner, so the same signature also authorizes upgradeToAndCall. canSkipChainIdValidation (lines 281-292) lets owner changes and upgrades be replayed across chains.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin; each wallet's owners control it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
