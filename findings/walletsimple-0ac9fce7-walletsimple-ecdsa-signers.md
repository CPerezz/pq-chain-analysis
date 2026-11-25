---
id: walletsimple-0ac9fce7-walletsimple-ecdsa-signers
format: 2
title: 'BitGo WalletSimple multisig: quantum attacker with two signer keys takes funds'
status: confirmed
severity: HIGH
justification: The co-signer is checked only by ECDSA and signers are fixed, so owners must move funds to a post-quantum
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0ac9fce7636af8fa933068a3a5ecb71f8177c4f3'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 22348000
  basis: held
activity:
  txs_90d: 6
impact: funds-loss
action: Move the funds, with two signers co-signing, to a post-quantum-capable wallet that BitGo provides.
evidence_level: source
checks:
- id: c1
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address comes from ecrecover over the operation hash.
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

This 2-of-3 BitGo multisig wallet accepts the second signer's approval when ecrecover returns a signer address. A quantum attacker who derives the sender's and co-signer's ECDSA keys can send the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer address recovered with ecrecover.

## Reviewer notes

### Mechanism

The wallet is a clone (45-byte proxy) of WalletSimple 0xe5dcdc13. Per kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig. verifyMultiSig takes otherSigner = recoverAddressFromSignature(operationHash, signature). That function (lines 513-547) unpacks r, s and v, enforces low-s, and returns ecrecover(operationHash, v, r, s) at line 546. verifyMultiSig then requires isSigner(otherSigner) and otherSigner != msg.sender before executing. Signers are set once by init and cannot be changed, and there is no ERC-1271 path. With the sending key and co-signer key recovered from their public keys, an attacker satisfies both checks.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin can rotate signers.
- Ruled out: Safe mode only limits recipients to signers, which the attacker is.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
