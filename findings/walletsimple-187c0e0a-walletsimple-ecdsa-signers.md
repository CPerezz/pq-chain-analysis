---
id: walletsimple-187c0e0a-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple funds open to a quantum attacker with two signer keys
status: confirmed
severity: HIGH
justification: Fixed ECDSA signers; two signers must move funds to a post-quantum wallet BitGo provides.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0x187c0e0aa33282096b39a33457939f1dc3ea8e0f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 19172003
  basis: held
activity:
  txs_90d: 3
impact: funds-loss
action: Move the funds to a post-quantum-capable wallet, co-signed by two signers, once BitGo provides one.
evidence_level: source
checks:
- id: c1
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  line: 265
  has: return ecrecover(operationHash, v, r, s);
  says: Co-signer is recovered with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: s-only
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  has: if (!isSigner(msg.sender)) {
  line: 86
  says: Sender must be a signer.
  for:
  - what
- id: s-verify
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  has: if (!isSigner(otherSigner)) {
  line: 220
  says: Recovered co-signer must be a signer.
  for:
  - evidence-2
  - what
- id: s-call
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  has: if (!(toAddress.call.value(value)(data))) {
  line: 135
  says: Wallet executes the arbitrary call/transfer.
  for:
  - what
- id: s-ctor
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  has: signers = allowedSigners;
  line: 64
  says: Signers set in the constructor.
  for:
  - evidence-3
  - justification
- id: s-fixed
  source: '0x187c0e0aa33282096b39a33457939f1dc3ea8e0f'
  file: WalletSimple.sol
  has: Signers CANNOT be changed once they are set
  line: 55
  says: Signers are immutable.
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

This 2-of-3 multisig sends ETH and tokens when a signer submits the transaction and a second signer's ECDSA signature recovers via ecrecover. A quantum attacker who derives two signer keys can sign and submit a transfer of everything; signers cannot be changed.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0x187c0e0aa33282096b39a33457939f1dc3ea8e0f#code) returns the ecrecover result as the co-signer.
- [verifyMultiSig](https://etherscan.io/address/0x187c0e0aa33282096b39a33457939f1dc3ea8e0f#code) reverts unless the recovered address is a signer.
- [constructor](https://etherscan.io/address/0x187c0e0aa33282096b39a33457939f1dc3ea8e0f#code) sets the signers once; the source states they cannot be changed.

## Reviewer notes

### Mechanism

sendMultiSig (line 121) and sendMultiSigToken (line 153) carry onlySigner (line 86: msg.sender must be in signers). Both call verifyMultiSig (line 196), which gets otherSigner from recoverAddressFromSignature (line 204), i.e. ecrecover (line 265), requires isSigner(otherSigner) (line 220) and otherSigner != msg.sender (line 224). sendMultiSig then does toAddress.call.value(value)(data) (line 135). Signers are set in the constructor (line 64) with no setter; comment line 55 says they cannot be changed. activateSafeMode (line 235) only limits destinations to signers, which an attacker holding a signer key is.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin.
- Ruled out: Safe mode does not stop an attacker holding a signer key.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
