---
id: walletsimple-b3d891c0-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple multisig is open to a quantum attacker with two signer keys
status: confirmed
severity: HIGH
justification: Signers are fixed ECDSA keys; only the signers moving funds to a post-quantum wallet BitGo provides
  fixes it.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb3d891c05febd428b782c242bf94dc73613549c9'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 41697
  basis: held
activity:
  txs_90d: 98
impact: funds-loss
action: Move the wallet's funds to a post-quantum-capable wallet, with BitGo providing one.
evidence_level: source
checks:
- id: c1
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer is recovered with ecrecover, an ECDSA check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xb3d891c05febd428b782c242bf94dc73613549c9'
  is: contract
  bytes: 45
  says: The wallet address holds 45 bytes of proxy code.
  for:
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
reviews: []
related: []
---

## What happens

This BitGo multisig wallet clone runs WalletSimple code and accepts the co-signer of a send through a signature checked with ecrecover. A quantum attacker who recovers the sending signer's key and the co-signer's ECDSA key can sign and send the wallet's funds to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer address from ecrecover on the operation hash.

## Reviewer notes

### Mechanism

The wallet is a 45-byte proxy delegating to WalletSimple at 0xe5dcdc13. Per kev's finding, sendMultiSig/sendMultiSigToken/sendMultiSigBatch are onlySigner and call verifyMultiSig, which sets otherSigner = recoverAddressFromSignature(operationHash, signature) and requires isSigner(otherSigner) and otherSigner != msg.sender. recoverAddressFromSignature (lines 513-547) unpacks r, s, v and returns ecrecover(operationHash, v, r, s) at line 546. Signers are set once by init and cannot be changed; there is no ERC-1271 path. An attacker with two signer keys recovered from on-chain public keys can send funds and pass the check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no admin to change signers or the verification.
- Ruled out: Safe mode only limits recipients to signers, which the attacker is.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
