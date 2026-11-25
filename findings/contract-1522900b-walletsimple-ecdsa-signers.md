---
id: contract-1522900b-walletsimple-ecdsa-signers
format: 2
title: Quantum attacker with two ECDSA signer keys can drain this BitGo wallet
status: confirmed
severity: HIGH
justification: Signers are fixed ECDSA keys, so owners must move funds to a post-quantum wallet from BitGo.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1522900b6dafac587d499a862861c0869be6e428'
  project: bitgo
  code: bytecode
  code_url: https://etherscan.io/address/0x1522900b6dafac587d499a862861c0869be6e428#code
  copies: 1
value:
  usd: 54648
  basis: held
activity:
  txs_90d: 12405
impact: funds-loss
action: Move the funds to a post-quantum-capable wallet; signers cannot be replaced in this contract.
evidence_level: source
checks:
- id: c1
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  line: 305
  has: return ecrecover(operationHash, v, r, s);
  says: second signer is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: s-only
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: function sendMultiSig(address toAddress, uint value, bytes data, uint expireTime, uint sequenceId, bytes
    signature) onlysigner {
  line: 170
  says: sendMultiSig requires a signer as sender
  for:
  - what
- id: s-verify
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: if (!isSigner(otherSigner)) {
  line: 248
  says: recovered co-signer must be a signer
  for:
  - evidence-2
  - what
- id: s-neq
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: if (otherSigner == msg.sender) {
  line: 252
  says: co-signer must differ from sender
  for:
  - evidence-2
- id: s-call
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: if (!(toAddress.call.value(value)(data))) {
  line: 177
  says: wallet sends value to any address after verification
  for:
  - what
- id: s-ctor
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: signers = allowedSigners;
  line: 137
  says: signers are set in the constructor
  for:
  - evidence-3
  - justification
  - what
- id: s-fixed
  source: '0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691'
  file: WalletSimple.sol
  has: Signers CANNOT be changed once they are set
  line: 128
  says: signers cannot be changed
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

This 2-of-3 wallet sends ETH or tokens when a signer submits the transaction and a second signer's signature recovers through ecrecover. A quantum attacker who derives two signers' private keys can send itself everything the wallet holds; the signer list is set once at creation.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691#code) returns the ecrecover result as the second signer.
- [verifyMultiSig](https://etherscan.io/address/0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691#code) accepts the recovered address if it is a signer different from the sender.
- [The constructor](https://etherscan.io/address/0x5b9e8728e316bbeb692d22daaab74f6cbf2c4691#code) sets the three signers, documented as unchangeable.

## Reviewer notes

### Mechanism

The address is a 51-byte forwarder that delegatecalls WalletSimple at 0x5b9e8728. sendMultiSig (line 170) and sendMultiSigToken (line 196) are onlysigner (msg.sender must be in signers, lines 117-122) and call verifyMultiSig (line 230), which recovers otherSigner via recoverAddressFromSignature -> ecrecover (line 305), requires isSigner(otherSigner) (line 248) and otherSigner != msg.sender (line 252), then performs toAddress.call.value(value)(data) (line 177) or token transfer (line 203). Signers are set in the constructor (lines 132-138), and no function modifies them. activateSafeMode (line 263) only limits destinations to signers, which an attacker holding a signer key satisfies.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Safe mode does not protect funds: the attacker's own signer address is an allowed destination.
- Ruled out: No ERC-1271 or other non-ECDSA co-signer path exists.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
