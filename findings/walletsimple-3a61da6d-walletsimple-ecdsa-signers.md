---
id: walletsimple-3a61da6d-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple lets a quantum attacker with two signer keys move all funds
status: confirmed
severity: HIGH
justification: Two ECDSA keys move everything and signers are fixed, so owners must move funds to a new wallet BitGo
  provides.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 8558368
  basis: held
activity:
  txs_90d: 6366
impact: funds-loss
action: Move funds to a post-quantum-capable wallet; signers cannot be replaced in this contract.
evidence_level: source
checks:
- id: c1
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  line: 265
  has: return ecrecover(operationHash, v, r, s);
  says: second signer is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: s-only
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: ) public onlySigner {
  line: 128
  says: sendMultiSig requires the sender to be a signer
  for:
  - what
- id: s-issigner
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: if (!isSigner(otherSigner)) {
  line: 220
  says: recovered address must be a signer
  for:
  - evidence-2
  - what
- id: s-notself
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: if (otherSigner == msg.sender) {
  line: 224
  says: co-signer must differ from sender
  for:
  - evidence-2
- id: s-call
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: if (!(toAddress.call.value(value)(data))) {
  line: 135
  says: wallet sends value to the chosen address
  for:
  - what
- id: s-ctor
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: signers = allowedSigners;
  line: 64
  says: signers are set in the constructor
  for:
  - evidence-3
  - justification
  - what
- id: s-fixed
  source: '0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb'
  file: WalletSimple.sol
  has: Signers CANNOT be changed once they are set
  line: 55
  says: signer set is fixed
  for:
  - action
  - evidence-3
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

This 2-of-3 multisig sends ETH or tokens when the sender is a signer and a second signer's ECDSA signature recovers via ecrecover. A quantum attacker who derives the sender's and co-signer's keys can send the wallet's funds to itself; signers are set in the constructor and never change.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb#code) returns the ecrecover result as the second signer.
- [verifyMultiSig](https://etherscan.io/address/0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb#code) accepts the recovered address if it is a signer other than the sender.
- [The constructor](https://etherscan.io/address/0x3a61da6d37493e2f248a6832f49b52af0a6f4fbb#code) sets the signer list, documented as unchangeable.

## Reviewer notes

### Mechanism

sendMultiSig (line 121) and sendMultiSigToken (line 153) carry onlySigner (msg.sender must be in signers, lines 85-90) and call verifyMultiSig (line 196). It gets otherSigner from recoverAddressFromSignature (line 204), which unpacks r,s,v and returns ecrecover(operationHash, v, r, s) (line 265). It requires isSigner(otherSigner) (line 220) and otherSigner != msg.sender (line 224), then sendMultiSig executes toAddress.call.value(value)(data) (line 135) or the token transfer (line 167). Signers are assigned once in the constructor (line 64, exactly 3) and no function modifies them (comment line 55). activateSafeMode (line 235) only limits destinations to signers, which an attacker holding a signer key is.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Safe mode does not protect funds: an attacker holding a signer key is an allowed destination.
- Ruled out: No upgrade or signer-rotation path exists in the source.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
