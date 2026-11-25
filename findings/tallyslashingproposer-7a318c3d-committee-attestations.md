---
id: tallyslashingproposer-7a318c3d-committee-attestations
format: 2
title: Aztec v0 slashing proposer accepts ECDSA votes a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signature check is ECDSA and fixed; Aztec Governance fixes it by registering a rollup version with
  post-quantum keys.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7a318c3daa9f21f8fc8238c65755eb0394fbf189'
  name: TallySlashingProposer
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x7a318c3daa9f21f8fc8238c65755eb0394fbf189#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a new rollup version whose slashing votes and attestations use post-quantum signatures.
evidence_level: source
checks:
- id: c1
  source: '0x7a318c3daa9f21f8fc8238c65755eb0394fbf189'
  file: lib/l1-contracts/src/shared/libraries/SignatureLib.sol
  line: 25
  has: address recovered = ECDSA.recover(_digest, _signature.v, _signature.r, _signature.s);
  says: Signature verification recovers the signer with ECDSA and compares it to the expected address.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7a318c3daa9f21f8fc8238c65755eb0394fbf189'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
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

This contract collects slashing votes for Aztec rollup version 0 and accepts a vote when ECDSA recovers the expected signer from its signature. A quantum attacker who derives a proposer's key from its public signatures can sign slashing votes as that proposer.

## Evidence

- [SignatureLib.verify](https://etherscan.io/address/0x7a318c3daa9f21f8fc8238c65755eb0394fbf189#code) accepts a signature when ECDSA.recover returns the expected signer.
- [ECDSA.tryRecover](https://etherscan.io/address/0x7a318c3daa9f21f8fc8238c65755eb0394fbf189#code) derives the signer with the secp256k1 ecrecover precompile.

## Reviewer notes

### Mechanism

TallySlashingProposer.vote (line 399 per the finding) takes the slot proposer's EIP-712 signature over the vote and checks it through SignatureLib.verify (line 25), which calls ECDSA.recover. That reaches ECDSA.tryRecover, which calls ecrecover (line 148) and requires the recovered address to equal the expected proposer. A quorum of votes executes a slash through the Slasher, and a Safe can veto it. A quantum attacker who recovers a proposer's secp256k1 key from its on-chain signatures can cast those votes. The scheme is fixed in code. Per the finding, version 0 is halted with no attesters, so no proposer is currently sampled.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Slashed stake is not paid to the voters, per the finding.
- Ruled out: Version 0 has no active attesters and made no calls in the 30-day window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
