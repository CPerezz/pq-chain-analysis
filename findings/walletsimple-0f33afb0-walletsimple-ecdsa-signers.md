---
id: walletsimple-0f33afb0-walletsimple-ecdsa-signers
format: 2
title: BitGo WalletSimple multisig trusts ECDSA keys a quantum attacker could recover
status: confirmed
severity: HIGH
justification: Signers are fixed ECDSA keys; with two keys recovered funds move, and only the signers can fix it
  by migrating.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0f33afb00334ea05f6f0e64fc919920ecd4bd16c'
  name: WalletSimple
  project: bitgo
  code: verified
  code_url: https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code
  proxy_of: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  copies: 1
  upgradeable: 'no'
value:
  usd: 19
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Move the wallet's funds to a post-quantum-capable wallet, with two signers co-signing the transfer.
evidence_level: source
checks:
- id: c1
  source: '0xe5dcdc13b628c2df813db1080367e929c1507ca0'
  file: contracts/WalletSimple.sol
  line: 546
  has: return ecrecover(operationHash, v, r, s);
  says: recoverAddressFromSignature returns the ecrecover result as the co-signer.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x0f33afb00334ea05f6f0e64fc919920ecd4bd16c'
  is: contract
  bytes: 45
  says: The address holds contract code (a proxy clone).
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This WalletSimple clone is a multisig whose second signer is accepted when ecrecover returns a signer's address. A quantum attacker who recovers the sending key and a co-signer's ECDSA key can authorize transfers out of the wallet.

## Evidence

- [recoverAddressFromSignature](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code) returns the signer address recovered with ecrecover.
- The wallet address holds a small proxy that runs the [WalletSimple code](https://etherscan.io/address/0xe5dcdc13b628c2df813db1080367e929c1507ca0#code).

## Reviewer notes

### Mechanism

The address is a minimal proxy clone running WalletSimple at 0xe5dcdc13. In that code, the multisig send functions require msg.sender to be a signer. They then call verifyMultiSig. verifyMultiSig derives the other signer with recoverAddressFromSignature (lines 513-547). That function unpacks r, s and v, rejects high-s values, and returns ecrecover(operationHash, v, r, s) at line 546. The result must be a signer that differs from msg.sender. Signers are set once by init and cannot be changed. An attacker who recovers two signer private keys can send from one key and sign with the other.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read
- Ruled out: Safe mode does not protect against an attacker holding a signer key

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
