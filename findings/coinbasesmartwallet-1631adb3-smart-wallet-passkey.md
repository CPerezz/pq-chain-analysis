---
id: coinbasesmartwallet-1631adb3-smart-wallet-passkey
format: 2
title: Coinbase Smart Wallet trusts owner keys that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Any one forged owner signature moves funds or upgrades; MEDIUM because owners can add a PQ signer
  and remove old ones.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1631adb3e1fdb65e7936272c89861cb2aac2906a'
  name: CoinbaseSmartWallet
  project: coinbase
  code: verified
  code_url: https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code
  proxy_of: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
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
  says: Address owners are checked with SignatureCheckerLib (ecrecover first).
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
- id: s-validate
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: if (_isValidSignature(userOpHash, userOp.signature)) {
  line: 191
  says: the line or bytes the card cites
  for:
  - what
- id: s-upg
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: function _authorizeUpgrade(address) internal view virtual override(UUPSUpgradeable) onlyOwner {}
  line: 352
  says: the line or bytes the card cites
  for:
  - evidence-3
  - justification
  - what
- id: s-exec
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: _call(target, value, data);
  line: 234
  says: the line or bytes the card cites
  for:
  - what
- id: s-addaddr
  source: '0x00000110dcdedc9581cb5ecb8467282f2926534d'
  file: src/CoinbaseSmartWallet.sol
  has: functionSelector == MultiOwnable.addOwnerAddress.selector
  line: 284
  says: the line or bytes the card cites
  for:
  - action
  - justification
- id: s-remove
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
  pattern: PQ-9
reviews: []
related: []
---

## What happens

This smart wallet accepts a user operation when one owner's signature verifies: a P-256 passkey via WebAuthn or an address owner via the signature checker. A quantum attacker who derives one owner's private key from its public key can sign as that owner, then drain the wallet or upgrade it.

## Evidence

- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks a 64-byte owner with WebAuthn.verify against its stored P-256 public key.
- [_isValidSignature](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) checks a 32-byte address owner with SignatureCheckerLib.isValidSignatureNow.
- [_authorizeUpgrade](https://etherscan.io/address/0x00000110dcdedc9581cb5ecb8467282f2926534d#code) requires onlyOwner, so any single owner can upgrade the wallet.

## Reviewer notes

### Mechanism

validateUserOp (line 154) computes the user-operation hash and calls _isValidSignature (line 191). _isValidSignature (lines 318-346) decodes a SignatureWrapper and loads ownerAtIndex(ownerIndex). A 32-byte owner is checked with SignatureCheckerLib.isValidSignatureNow (line 334), which tries ecrecover first. A 64-byte owner is a P-256 key (x, y) checked with WebAuthn.verify (line 342). WebAuthn.verify tries precompile 0x100 and falls back to FCL_ecdsa.ecdsa_verify (line 162). After validation, execute/executeBatch (lines 228, 242) move funds. _authorizeUpgrade is onlyOwner (line 352). canSkipChainIdValidation (lines 281-292) allows owner changes and upgradeToAndCall through executeWithoutChainIdValidation, so one signature replays on every chain where the wallet exists. Owners are stored on-chain, so P-256 public keys are exposed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No contract-wide admin; each wallet's owners control it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
