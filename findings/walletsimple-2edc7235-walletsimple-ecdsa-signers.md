---
id: walletsimple-2edc7235-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple lets a quantum attacker with two signer keys take funds
status: confirmed
severity: HIGH
justification: 'ECDSA co-signer check, fixed signers: signers must move funds to a post-quantum wallet BitGo provides.'
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2edc7235fbebc560f59d55f206e340102f11aca5'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 19360001
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Provide a post-quantum-capable wallet so the signers can move the funds out of this wallet.
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
- id: code
  code: '0x2edc7235fbebc560f59d55f206e340102f11aca5'
  is: contract
  bytes: 45
  says: The wallet address is a small contract (clone) with code.
  for:
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

This WalletSimple multisig clone sends funds when a signer submits the transaction and a second signer's ECDSA signature recovers via ecrecover. A quantum attacker who derives two signer keys can send its holdings to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer address recovered by ecrecover.

## Reviewer notes

### Mechanism

The address is a 45-byte clone delegating to WalletSimple 0xe5dcdc13. sendMultiSig, sendMultiSigToken and sendMultiSigBatch are onlySigner and call verifyMultiSig. verifyMultiSig takes otherSigner from recoverAddressFromSignature (line 546: ecrecover(operationHash, v, r, s)). It requires otherSigner to be a signer distinct from msg.sender, then executes the transfer. Per kev, signers are set once by init and there is no function that changes them or any ERC-1271 path. With the sender's and co-signer's keys recovered from on-chain public keys, an attacker controls both roles. activateSafeMode only restricts destinations to signers, which the attacker is.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin can swap the verification logic.
- Ruled out: Safe mode does not stop an attacker holding a signer key.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
