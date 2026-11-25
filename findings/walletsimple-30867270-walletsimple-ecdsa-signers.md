---
id: walletsimple-30867270-walletsimple-ecdsa-signers
format: 2
title: BitGo multisig signers' ECDSA keys let a quantum attacker drain it
status: confirmed
severity: HIGH
justification: Second signer is checked by ECDSA and signers are fixed, so funds stay at risk until signers move
  them to a new wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x308672703961164e64332ba1ce19b85827502b4d'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 17724223
  basis: held
activity:
  txs_90d: 32
impact: funds-loss
action: Provide a post-quantum-capable wallet and have the signers move the funds to it.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer's address is recovered from an ECDSA signature with ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (source read, one real transaction replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This 2-of-3 BitGo multisig accepts a send when a signer submits it with a co-signer's ECDSA signature, recovered with ecrecover. A quantum attacker who derives the sender's and co-signer's keys from their public keys can move the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) returns the co-signer address from ecrecover over the operation hash.

## Reviewer notes

### Mechanism

The wallet is a clone delegating to WalletSimple 0xe8e847cf. sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig, which takes otherSigner = recoverAddressFromSignature(operationHash, signature). That function (lines 566-600) checks length and low-s, then returns ecrecover(operationHash, v, r, s) at line 599. verifyMultiSig requires isSigner(otherSigner) and otherSigner != msg.sender, then executes the transfer or call. Signers are set once by init and there is no function to change them; the contract is not upgradeable. There is no ERC-1271 path, so the co-signer must be an ECDSA key. activateSafeMode only restricts destinations to signers, which an attacker holding a signer key is.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: signers cannot be rotated in place
- Ruled out: Safe mode does not protect against a stolen signer key

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
