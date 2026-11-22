---
id: keymanager-cd351d36-aggkey-schnorr-ecrecover
format: 2
title: Chainflip KeyManager trusts a Schnorr key a quantum attacker could recover
status: confirmed
severity: MEDIUM
justification: Forged aggregate-key signatures pass; Chainflip can fix it by repointing consumers to a post-quantum
  KeyManager.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xcd351d3626dc244730796a3168d315168ebf08be'
  name: KeyManager
  project: chainflip
  code: verified
  code_url: https://etherscan.io/address/0xcd351d3626dc244730796a3168d315168ebf08be#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 56018
impact: funds-loss
action: Deploy a KeyManager with a post-quantum scheme and repoint Vault and StateChainGateway to it with updateKeyManager.
evidence_level: source
checks:
- id: c2
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: SchnorrSECP256K1.sol
  line: 137
  has: address recoveredAddress = ecrecover(
  says: verifySignature calls ecrecover over secp256k1.
  for:
  - action
  - evidence-2
  - justification
- id: c3
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  line: 59
  has: verifySignature(msgHash, sigData.sig, key.pubKeyX, key.pubKeyYParity, sigData.kTimesGAddress),
  says: _consumeKeyNonce requires a Schnorr signature by the stored aggregate key.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: SchnorrSECP256K1.sol
  line: 102
  has: function verifySignature(
  says: verifySignature is the Schnorr secp256k1 verifier.
  for:
  - evidence-2
  - what
- id: consume
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  has: function consumeKeyNonce(SigData calldata sigData, bytes32 contractMsgHash) external override {
  line: 81
  says: External signature check other contracts call.
  for:
  - what
- id: getagg
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  has: function getAggregateKey() external view override returns (Key memory) {
  line: 196
  says: Aggregate public key is readable on-chain.
  for:
  - what
- id: upd-agg
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  has: function setAggKeyWithAggKey(
  line: 95
  says: Aggregate key signature can rotate the aggregate key.
  for:
  - evidence-3
  - justification
  - what
- id: upd-gov
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  has: function setGovKeyWithAggKey(
  line: 128
  says: Aggregate key signature can replace the governance key.
  for:
  - what
- id: upd-comm
  source: '0xcd351d3626dc244730796a3168d315168ebf08be'
  file: KeyManager.sol
  has: function setCommKeyWithAggKey(
  line: 157
  says: Aggregate key signature can replace the community key.
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

KeyManager checks signatures by the validators' secp256k1 Schnorr aggregate key for the contracts that consume its nonces. The aggregate public key is stored on-chain, so a quantum attacker who recovers its secret signs any message and can replace the aggregate, governance and community keys.

## Evidence

- [_consumeKeyNonce](https://etherscan.io/address/0xcd351d3626dc244730796a3168d315168ebf08be#code) requires verifySignature against the stored aggregate key.
- [verifySignature](https://etherscan.io/address/0xcd351d3626dc244730796a3168d315168ebf08be#code) uses ecrecover on secp256k1 to check the Schnorr equation.
- [setAggKeyWithAggKey](https://etherscan.io/address/0xcd351d3626dc244730796a3168d315168ebf08be#code) lets an aggregate-key signature rotate the key itself.

## Reviewer notes

### Mechanism

consumeKeyNonce (KeyManager.sol line 81) hashes contractMsgHash with nonce, msg.sender, chain id and its own address, then calls _consumeKeyNonce (line 55), which requires verifySignature(msgHash, sig, aggKey.pubKeyX, pubKeyYParity, kTimesGAddress) at line 59. SchnorrSECP256K1.verifySignature (line 102) calls ecrecover at line 137 as a curve gadget computing e*PK+s*G and compares the address with kTimesGAddress. Security rests on the discrete log of the aggregate key, which getAggregateKey (line 196) exposes. With the recovered secret an attacker signs consumer calls (Vault transfers, StateChainGateway redemptions and FLIP supply updates) and KeyManager's own setAggKeyWithAggKey, setGovKeyWithAggKey and setCommKeyWithAggKey (lines 95, 128, 157) via consumeKeyNonceKeyManager.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: KeyManager is not a proxy and holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
