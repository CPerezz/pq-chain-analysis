---
id: walletsimple-2e6b9ede-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple multisig lets a quantum attacker forge its ECDSA signers
status: confirmed
severity: HIGH
justification: Signers are fixed ECDSA keys checked by ecrecover; only signers moving funds to a new PQ wallet fixes
  it.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2e6b9ede9421bd2b2647d3da76e4671ba10bbd67'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 27162679
  basis: held
activity:
  txs_90d: 52
impact: funds-loss
action: Signers co-sign moving all funds to a post-quantum-capable wallet that BitGo provides.
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
  code: '0x2e6b9ede9421bd2b2647d3da76e4671ba10bbd67'
  is: contract
  bytes: 45
  says: The wallet address holds contract code (a proxy).
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

This BitGo 2-of-3 multisig wallet runs behind a proxy and moves funds when a signer sends and a second signer's signature recovers through ecrecover. A quantum attacker who derives two signers' ECDSA keys from their public keys can send the wallet's holdings to itself.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the co-signer as ecrecover(operationHash, v, r, s).

## Reviewer notes

### Mechanism

The wallet address holds a small proxy (45 bytes) running WalletSimple at 0xe5dcdc13. sendMultiSig and its token and batch variants are onlySigner and call verifyMultiSig. verifyMultiSig takes the second signer from recoverAddressFromSignature (lines 513-547), which unpacks r, s, v and returns ecrecover(operationHash, v, r, s) at line 546. It then requires that this address is a signer and differs from msg.sender. Kev reports that the signers are set once by init and cannot be changed. An attacker holding two recovered signer keys can therefore submit the transaction as one signer and forge the other signer's signature.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Upgrade path: the contract is not upgradeable
- Ruled out: Changing signers: signers are set once at init (per kev)
- Ruled out: activateSafeMode: it allows sends to signers, and the attacker holds a signer key

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
