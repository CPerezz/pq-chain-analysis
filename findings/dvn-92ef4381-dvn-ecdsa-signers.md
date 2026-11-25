---
id: dvn-92ef4381-dvn-ecdsa-signers
format: 2
title: LayerZero DVN trusts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: DVN checks only secp256k1 quorum signatures; MEDIUM as the operator can redeploy a post-quantum DVN
  and configs repoint.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x92ef4381a03372985985e70fb15e9f081e2e8d14'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x92ef4381a03372985985e70fb15e9f081e2e8d14#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0x92ef4381a03372985985e70fb15e9f081e2e8d14'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x92ef4381a03372985985e70fb15e9f081e2e8d14'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A recovery error rejects the signature set.
  for:
  - what
- id: c3
  source: '0x92ef4381a03372985985e70fb15e9f081e2e8d14'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x92ef4381a03372985985e70fb15e9f081e2e8d14'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the contract itself via quorum.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This DVN accepts a call only when a quorum of 65-byte ECDSA signatures recovers to its committee signers. A quantum attacker who derives the signer keys could forge that quorum and get fake cross-chain messages verified. Signers can be replaced, but only with other ECDSA keys.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x92ef4381a03372985985e70fb15e9f081e2e8d14#code) recovers each signer with ECDSA.tryRecover over the signed hash.
- [tryRecover](https://etherscan.io/address/0x92ef4381a03372985985e70fb15e9f081e2e8d14#code) calls the ecrecover precompile on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0x92ef4381a03372985985e70fb15e9f081e2e8d14#code) is onlySelf and sets signer addresses checked by ecrecover.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 81-99) requires signatures.length == quorum*65, computes the EIP-191 digest, and for each 65-byte slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); it requires no error (line 93), ascending signers (line 94) and committee membership (line 95). Per kev's finding, DVN.execute gates target calls such as ReceiveUln302.verify on this check, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and only rotates to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable.
- Ruled out: DVN holds no funds itself; value sits in the OApps relying on it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
