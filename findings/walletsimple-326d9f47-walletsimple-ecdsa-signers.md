---
id: walletsimple-326d9f47-walletsimple-ecdsa-signers
format: 2
title: Quantum attacker with two ECDSA signer keys can drain BitGo wallet
status: confirmed
severity: HIGH
justification: Two ECDSA signer keys move all funds; signers are fixed, so owners must move funds to a new BitGo
  wallet.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x326d9f47ba49bbaac279172634827483af70a601'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0x326d9f47ba49bbaac279172634827483af70a601#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 20664449
  basis: held
activity:
  txs_90d: 123
impact: funds-loss
action: Provide a post-quantum-capable wallet and have the signers co-sign moving the funds into it.
evidence_level: source
checks:
- id: c1
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  line: 265
  has: return ecrecover(operationHash, v, r, s);
  says: co-signer address is recovered with ECDSA ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: s-onlysigner
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: ) public onlySigner {
  line: 128
  says: sendMultiSig is callable only by a signer
  for:
  - evidence-1
  - justification
  - what
- id: s-issigner
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: if (!isSigner(otherSigner)) {
  line: 220
  says: recovered co-signer must be a wallet signer
  for:
  - evidence-2
  - justification
  - what
- id: s-notself
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: if (otherSigner == msg.sender) {
  line: 224
  says: co-signer must differ from the sender
  for:
  - evidence-2
- id: s-ctor
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: signers = allowedSigners;
  line: 64
  says: signers set in the constructor
  for:
  - evidence-3
  - what
- id: s-fixed
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: Signers CANNOT be changed once they are set
  line: 55
  says: signer set is immutable
  for:
  - action
  - evidence-3
  - justification
  - what
- id: s-call
  source: '0x326d9f47ba49bbaac279172634827483af70a601'
  file: WalletSimple.sol
  has: if (!(toAddress.call.value(value)(data))) {
  line: 135
  says: wallet sends value to the chosen address
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This 2-of-3 wallet sends ETH and tokens when a signer submits the transaction and a second signer's signature, checked with ecrecover, matches. Signers are set at deployment and cannot change, so a quantum attacker who recovers two signer keys can send all funds to itself.

## Evidence

- [sendMultiSig](https://etherscan.io/address/0x326d9f47ba49bbaac279172634827483af70a601#code) is restricted to signers and the co-signer comes from ecrecover over the operation hash.
- [verifyMultiSig](https://etherscan.io/address/0x326d9f47ba49bbaac279172634827483af70a601#code) accepts the recovered address if it is a signer other than the sender.
- [The constructor](https://etherscan.io/address/0x326d9f47ba49bbaac279172634827483af70a601#code) fixes three signers; the code states signers cannot be changed.

## Reviewer notes

### Mechanism

sendMultiSig (line 121) and sendMultiSigToken (line 153) carry onlySigner (msg.sender must be in signers, lines 85-90) and call verifyMultiSig (line 196), which sets otherSigner = recoverAddressFromSignature(operationHash, signature) (line 204), which returns ecrecover(operationHash, v, r, s) (line 265). It requires isSigner(otherSigner) (line 220) and otherSigner != msg.sender (line 224), then the wallet does toAddress.call.value(value)(data) (line 135) or an ERC-20 transfer (line 167). Signers are written only in the constructor (line 64, exactly 3); no function changes them. activateSafeMode (line 235) only limits destinations to signer addresses, which an attacker holding a signer key controls.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No upgrade path or admin.
- Ruled out: Safe mode does not protect against a stolen signer key.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
