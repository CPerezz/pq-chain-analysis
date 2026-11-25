---
id: dvn-394fe818-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages; DVN operator must deploy a post-quantum DVN and configs
  repoint to it.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x394fe81886baf6e2d5bee37ffa24b07133c320c6'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x394fe81886baf6e2d5bee37ffa24b07133c320c6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13200
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0x394fe81886baf6e2d5bee37ffa24b07133c320c6'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x394fe81886baf6e2d5bee37ffa24b07133c320c6'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: a failed ECDSA recovery rejects the signature set
  for:
  - evidence-1
  - what
- id: c3
  source: '0x394fe81886baf6e2d5bee37ffa24b07133c320c6'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x394fe81886baf6e2d5bee37ffa24b07133c320c6'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the contract itself via quorum
  for:
  - action
  - evidence-3
  - justification
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

This DVN verifies LayerZero cross-chain messages for OApps and accepts a call when a quorum of its signers' ECDSA signatures recovers to committee members. A quantum attacker who recovers the signer keys forges that quorum and verifies fabricated messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x394fe81886baf6e2d5bee37ffa24b07133c320c6#code) recovers each 65-byte signature with ECDSA.tryRecover and checks the signer is in the committee.
- [tryRecover](https://etherscan.io/address/0x394fe81886baf6e2d5bee37ffa24b07133c320c6#code) calls the ecrecover precompile on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0x394fe81886baf6e2d5bee37ffa24b07133c320c6#code) is onlySelf and rotates signers to other ECDSA-checked addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires signatures of length quorum*65, prefixes the hash with the Ethereum signed-message header, and for each slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139); a recovery error fails (line 106), signers must be ascending and in signerSet. DVN.execute relies on this check before calling targets such as ReceiveUln302.verify, so a forged quorum verifies packets OApps then execute. setSigner (DVN.sol line 104) is onlySelf, so rotation goes only to other ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable.
- Ruled out: Contract holds no funds itself; funds sit in OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
