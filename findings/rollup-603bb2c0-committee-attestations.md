---
id: rollup-603bb2c0-committee-attestations
format: 2
title: Aztec Rollup v0 trusts ECDSA attestations that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: The attester ECDSA check is fixed in code; only Governance can fix it, by registering a new post-quantum
  rollup version.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  name: Rollup
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code
  copies: 1
  admin: '0x1102471eb3378fee427121c9efcea452e4b6b75e'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 112
impact: funds-loss
action: Register a new rollup version whose attestations use post-quantum signatures, and move portals and users
  to it.
evidence_level: source
checks:
- id: c1
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: SignatureLib.verify recovers the signer with ECDSA.recover.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.tryRecover calls the ecrecover precompile.
  for:
  - what
- id: c4
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/ValidatorSelectionLib.sol
  line: 339
  has: stack.reconstructedCommittee[i] = ECDSA.recover(digest, v, r, s);
  says: verifyAttestations rebuilds the committee with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x603bb2c05d474794ea97805e8de69bccfb3bca12'
  file: lib/l1-contracts/src/core/libraries/rollup/InvalidateLib.sol
  line: 109
  has: (recovered,,) = ECDSA.tryRecover(digest, signature.v, signature.r, signature.s);
  says: invalidateBadAttestation checks attestations with ECDSA.tryRecover.
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review00 (Sourcify/Blockscout source of rollup versions 0, 2 and 3; Registry, GSE, Governance and portal
    reads; Xatu activity of the new contracts)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Aztec rollup version rebuilds the block committee by recovering each attester's ECDSA signature, and checks the proposer's signature the same way. A quantum attacker who derives attester keys from their public signatures could sign proposals and attestations as those validators.

## Evidence

- [verifyAttestations](https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code) rebuilds the committee with ECDSA.recover over each attestation.
- [SignatureLib.verify](https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code) accepts a signature if ECDSA recovers the expected signer.
- [invalidateBadAttestation](https://etherscan.io/address/0x603bb2c05d474794ea97805e8de69bccfb3bca12#code) also judges attestations with ECDSA.tryRecover.

## Reviewer notes

### Mechanism

Rollup.propose calls ValidatorSelectionLib, which verifies the proposer's signature through SignatureLib.verify (line 25: ECDSA.recover, then require signer == recovered). In verifyAttestations (line 339), each committee member's attestation is recovered with ECDSA.recover into reconstructedCommittee, which is matched against the stored committee commitment. InvalidateLib.invalidateBadAttestation (line 109) uses ECDSA.tryRecover, which reaches ecrecover (ECDSA.sol line 148). Every gate on who may propose or attest is secp256k1 ECDSA, so recovered private keys let an attacker pass them. Releasing portal funds also needs a forged epoch proof; that is a separate finding. Kev records that this version has no active attesters and proven = pending, so no committee can currently be sampled.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0; its own AZTEC is rewards already owed, which forged blocks do not unlock.
- Ruled out: Version 0 has no active attesters, so it cannot currently propose blocks.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
