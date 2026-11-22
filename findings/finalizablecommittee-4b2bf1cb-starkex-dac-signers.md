---
id: finalizablecommittee-4b2bf1cb-starkex-dac-signers
format: 2
title: Reddio StarkEx committee takes ECDSA attestations a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Forged quorum attestations could approve withheld data and lock users out; Reddio's governor can
  swap the verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669'
  name: FinalizableCommittee
  project: reddio
  code: verified
  code_url: https://etherscan.io/address/0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Register an availability verifier with post-quantum member signatures, or move data on-chain, before state
  updates resume.
evidence_level: source
checks:
- id: c1
  source: '0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669'
  file: Committee.sol
  line: 77
  has: address recovered = ecrecover(claimHash, v, r, s);
  says: Signers are recovered with ECDSA ecrecover over the claim hash.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c80
  source: '0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 80
  says: Each recovered signer must be a committee member.
  for:
  - evidence-2
  - justification
  - what
- id: c84
  source: '0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 84
  says: The claim is registered as a fact after the signature checks pass.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This committee registers a data-availability fact once enough member ECDSA signatures over the claim hash recover to committee members. A quantum attacker who derives member keys (and the operator key) could attest to batches whose data is withheld, locking users out of escape.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669#code) recovers each signer with ecrecover over the claim hash.
- [verifyAvailabilityProof](https://etherscan.io/address/0x4b2bf1cb06cb636e8a14540f76c477e61d8b6669#code) requires each recovered address to be a member, then registers the fact.

## Reviewer notes

### Mechanism

Committee.verifyAvailabilityProof (lines 61-85) checks that the proof length covers signaturesRequired 65-byte signatures, then for each one reads r, s, v, calls ecrecover(claimHash, v, r, s) (line 77), requires isMember[recovered] (line 80) and strictly increasing addresses (line 81), and calls registerFact(claimHash) (line 84). The StarkExchange's operator-only updateState needs this fact alongside the STARK fact, so forging the member signatures plus the operator key lets a state with withheld data through; a false state still cannot be proven. FinalizableCommittee lets the admin add members and raise the threshold until it is finalized.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged quorum cannot make the exchange accept an invalid state transition; transitions are STARK-proven.
- Ruled out: The contract holds no funds itself and is not upgradeable.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
