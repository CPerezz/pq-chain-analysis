---
id: walletsimple-b66410ae-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple multisig lets a quantum attacker forge ECDSA co-signatures
status: confirmed
severity: HIGH
justification: Signer keys are ECDSA and fixed; only the signers moving funds to a post-quantum wallet BitGo provides
  fixes it.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb66410ae75317faf13dba869b6df7b30892d1e46'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code
  proxy_of: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  copies: 1
  upgradeable: 'no'
value:
  usd: 21331869
  basis: held
activity:
  txs_90d: 12
impact: funds-loss
action: Move the funds, with two signers co-signing, to a post-quantum-capable wallet once BitGo provides one.
evidence_level: source
checks:
- id: c1
  source: '0xe8e847cf573fc8ed75621660a36affd18c543d7e'
  file: FlattenedWalletSimple.sol
  line: 599
  has: return ecrecover(operationHash, v, r, s);
  says: The co-signer address comes from ecrecover over the operation hash.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0xb66410ae75317faf13dba869b6df7b30892d1e46'
  is: contract
  bytes: 45
  says: The wallet address holds 45 bytes of code, a proxy clone.
  for:
  - evidence-2
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
reviews: []
related: []
---

## What happens

This BitGo WalletSimple multisig moves its funds when a signer sends the call and a second signer's signature recovers through ecrecover. A quantum attacker who derives two signer keys from their public keys can sign and send transfers of the wallet's holdings to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code) returns the co-signer address from ecrecover over the operation hash.
- The wallet address holds a short proxy that runs the [WalletSimple code](https://etherscan.io/address/0xe8e847cf573fc8ed75621660a36affd18c543d7e#code).

## Reviewer notes

### Mechanism

The wallet is a 45-byte clone running the WalletSimple code. Per kev's finding, sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig, which obtains otherSigner from recoverAddressFromSignature (line 599: ecrecover(operationHash, v, r, s)), requires it to be a signer distinct from msg.sender, then executes the transfer. The signers are set once by init and cannot be changed, and there is no ERC-1271 path. A quantum attacker holding the sending key and a co-signer key (both public once used on chain) passes both checks. activateSafeMode only restricts destinations to signers, which the attacker is.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgrade: the code is not upgradeable and has no admin.
- Ruled out: Safe mode: it allows sends to signer addresses, which the attacker controls.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
