---
id: dsloprotocol-cab2fa2e-order-sig-ecdsa-first
format: 2
title: KyberSwap DS limit orders trust ECDSA keys a quantum attacker can recover
status: confirmed
severity: MEDIUM
justification: Old ECDSA keys still sign for migrated makers; KyberSwap must repoint the cosigner or redeploy.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  name: DSLOProtocol
  project: kyberswap
  code: verified
  code_url: https://etherscan.io/address/0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c#code
  copies: 1
  upgradeable: 'no'
  admin: '0x2475039bf2ecdce2ee4c82954e64be9674f43546'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 67672
impact: funds-loss
action: Point updateDSOrderSigner at a post-quantum ERC-1271 cosigner that refuses ECDSA signatures from makers
  with code.
evidence_level: source
checks:
- id: c1
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 1383
  has: SignatureChecker.isValidSignatureNow(
  says: fillOrderTo checks the cosigner's op signature via SignatureChecker
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 1404
  has: SignatureChecker.isValidSignatureNow(
  says: fillOrderTo checks the maker's order signature via SignatureChecker
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 186
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls ecrecover
  for:
  - what
- id: c4
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 588
  has: function isValidSignatureNow(
  says: SignatureChecker.isValidSignatureNow is defined here
  for:
  - evidence-2
- id: c5
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 593
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
  says: isValidSignatureNow tries ECDSA recovery first
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c'
  file: DSLOProtocol.sol
  line: 594
  has: if (error == ECDSA.RecoverError.NoError && recovered == signer) {
  says: a matching ECDSA recovery returns true before ERC-1271
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
  who: Review13 (re-read verified source on Sourcify; storage, owner and maker reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

DSLOProtocol fills limit orders after checking a KyberSwap cosigner signature and, on first fill, the maker's. Both checks accept a matching ECDSA signature before ERC-1271, so a quantum attacker with both keys can sell a maker's approved tokens.

## Evidence

- [fillOrderTo](https://etherscan.io/address/0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c#code) requires the cosigner's op signature, then the maker's order signature on first fill.
- [isValidSignatureNow](https://etherscan.io/address/0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c#code) returns true when ECDSA recovery matches the signer, before any ERC-1271 call.

## Reviewer notes

### Mechanism

fillOrderTo (line 1356) computes dsOrderHash and requires SignatureChecker.isValidSignatureNow(_dsOrderSigner, dsOrderHash, opSignature) (lines 1382-1387). On the first fill it requires isValidSignatureNow(order.maker, orderHash, orderSignature) (lines 1403-1408). The embedded SignatureChecker (lines 588-602) first calls ECDSA.tryRecover (line 593, ecrecover at line 186) and returns true if the recovered address equals the signer (line 594); only otherwise does it call ERC-1271 isValidSignature on the signer. A maker who migrates its address to post-quantum authorisation keeps accepting signatures from its old ECDSA key. The cosigner _dsOrderSigner is an EOA, so an attacker who recovers both keys can fill the maker's orders at any price against the maker's approvals. _dsOrderSigner is changeable by the owner multisig via updateDSOrderSigner (onlyOwner).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not a proxy and holds about $0 itself; exposure is makers' approvals.
- Ruled out: Unmigrated EOA makers are not additionally exposed: their old key already controls their funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
