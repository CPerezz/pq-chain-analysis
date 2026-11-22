---
id: coinbasesmartwallet-2ea269e0-smart-wallet-passkey
format: 2
title: Coinbase Smart Wallet owners' keys can be forged by a quantum attacker
status: confirmed
severity: MEDIUM
justification: One owner's P-256 or ECDSA key controls the wallet; owners fix it by adding a post-quantum signer,
  removing old ones.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2ea269e0102e70817be5929662e47ee7a0980b95'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code
  proxy_of: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 4
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
  says: Address owners are checked by SignatureCheckerLib (ecrecover first).
  for:
  - evidence-2
  - justification
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
- id: s-sel
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: bytes memory ownerBytes = ownerAtIndex(sigWrapper.ownerIndex);
  line: 320
  says: the line or bytes the card cites
  for:
  - what
- id: s-only
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (_isValidSignature(userOpHash, userOp.signature)) {
  line: 191
  says: the line or bytes the card cites
  for:
  - action
  - justification
- id: s-exec
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: _call(target, value, data);
  line: 234
  says: the line or bytes the card cites
  for:
  - what
- id: s-auth
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 352
  says: the line or bytes the card cites
  for:
  - evidence-3
  - justification
  - what
- id: s-skip
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: '|| functionSelector == UUPSUpgradeable.upgradeToAndCall.selector'
  line: 287
  says: the line or bytes the card cites
  for:
  - evidence-3
  - what
- id: s-addaddr
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: '|| functionSelector == MultiOwnable.addOwnerAddress.selector'
  line: 284
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

This wallet accepts a signature from any one owner, checking a 64-byte owner as a P-256 passkey and a 32-byte owner as an address via ECDSA recovery or ERC-1271. A quantum attacker who derives one owner's private key can sign operations that move funds, change owners or upgrade the wallet.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) verifies passkey owners with WebAuthn P-256 over the owner's stored (x, y) key.
- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks address owners with SignatureCheckerLib.isValidSignatureNow.
- [_authorizeUpgrade](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) is onlyOwner, and upgradeToAndCall may skip chain ID validation.

## Reviewer notes

### Mechanism

validateUserOp (line 191) and ERC-1271 isValidSignature both call _isValidSignature (lines 318-346). It decodes a SignatureWrapper, loads ownerAtIndex(ownerIndex) (line 320). A 32-byte owner goes to SignatureCheckerLib.isValidSignatureNow (line 334), which tries ecrecover for 64/65-byte signatures before ERC-1271. A 64-byte owner is a P-256 public key verified by WebAuthn.verify (line 342): RIP-7212 precompile at 0x100 (WebAuthn line 52-153), falling back to FreshCryptoLib ecdsa_verify (line 162). A valid signature lets the EntryPoint run execute/executeBatch (lines 228-246) to move funds, and self-calls to owner management and upgradeToAndCall, which _authorizeUpgrade gates with onlyOwner (line 352). canSkipChainIdValidation (lines 281-292) lets owner changes and upgrades be replayed across chains. The P-256 public key sits in storage, so a quantum attacker can derive the private key and forge signatures.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin; each wallet's funds belong to its own owners.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
