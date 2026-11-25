---
id: dvn-e552485d-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum lets fake messages verify; the operator must deploy a post-quantum DVN and configs
  must switch.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 35
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: Any recovery failure rejects the batch; success means accepted.
  for:
  - what
- id: c3
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer rotation is onlySelf and takes an address.
  for:
  - evidence-3
  - justification
- id: q1
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Exactly quorum signatures are required.
  for:
  - what
- id: q2
  source: '0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Recovered signer must be in the signer set.
  for:
  - evidence-1
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

This DVN acts on a call only when a quorum of its signer set has signed it, each signature checked with ECDSA recovery. A quantum attacker who derives a quorum of signer keys can sign fabricated message verifications that OApps relying on this DVN accept.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2#code) recovers each 65-byte signature with ECDSA.tryRecover and checks it against the signer set.
- [tryRecover](https://etherscan.io/address/0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0xe552485d02edd3067fe7fcbd4dd56bb1d3a998d2#code) rotates signers by address, so replacements are again ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires signatures.length == quorum*65 (line 82), hashes with the Ethereum signed-message prefix (line 86), then for each 65-byte slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); it rejects errors (93), non-ascending signers (94) and non-members (95). In the DVN this gates execute, whose calls in practice are ReceiveUln302.verify; once all of an OApp's required DVNs verify, the payload is committed to EndpointV2 and lzReceive releases or mints funds. setSigner (DVN.sol line 99) is onlySelf and only swaps in other ECDSA signer addresses. The DVN itself holds about nothing; funds sit in the OApps that require it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds no funds itself.
- Ruled out: Not upgradeable; no proxy admin read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
