---
id: walletsimple-bafbf3f8-walletsimple-ecdsa-signers
format: 2
title: BitGo multisig lets a quantum attacker with two signer keys take funds
status: confirmed
severity: HIGH
justification: Co-signer approval is plain ECDSA and signers are fixed, so owners must move funds to a post-quantum
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbafbf3f8f244828caf4e93295c9174fa8b63e032'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 27198328
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Move the wallet's funds to a post-quantum-capable wallet, with two signers co-signing, once BitGo provides
  one.
evidence_level: source
checks:
- id: c1
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer is recovered from the signature with ecrecover (ECDSA).
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xbafbf3f8f244828caf4e93295c9174fa8b63e032'
  is: contract
  bytes: 45
  says: The wallet address holds contract code (45 bytes).
  for:
  - evidence-2
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

This BitGo multisig wallet moves funds when one signer sends the transaction and a second signer's ECDSA signature recovers via ecrecover. A quantum attacker who derives two signers' private keys from their public keys can send the wallet's holdings to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer address from ecrecover.
- The wallet address holds contract code that runs the [WalletSimple code](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code).

## Reviewer notes

### Mechanism

Clone of WalletSimple 0xe5dcdc13. Per kev: sendMultiSig/sendMultiSigToken/sendMultiSigBatch are onlySigner and call verifyMultiSig, which sets otherSigner = recoverAddressFromSignature(operationHash, signature), requires isSigner(otherSigner) and otherSigner != msg.sender, then executes. recoverAddressFromSignature (lines 513-547) unpacks r,s,v, enforces low-s, and returns ecrecover(operationHash, v, r, s) at line 546. Signers are set once in init (exactly 3, onlyUninitialized) and cannot be changed; there is no ERC-1271 path. activateSafeMode only restricts destinations to signers, which an attacker holding a signer key satisfies. Kev lists the sending key 0x376df20b… with nonce 14, so its public key is exposed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgradeable proxy: not upgradeable, no admin
- Ruled out: Signer rotation: signers fixed at init
- Ruled out: Safe mode: allows sends to signer addresses, including the attacker's

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
