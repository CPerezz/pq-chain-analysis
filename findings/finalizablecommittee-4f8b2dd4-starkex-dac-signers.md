---
id: finalizablecommittee-4f8b2dd4-starkex-dac-signers
format: 2
title: tanX StarkEx data committee relies on quantum-forgeable ECDSA signatures
status: confirmed
severity: MEDIUM
justification: Forged attestations plus the operator key could hide state data; tanX's governor must register a
  PQ verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446'
  name: FinalizableCommittee
  project: tanx
  code: verified
  code_url: https://etherscan.io/address/0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Deploy and register a post-quantum availability verifier on the exchange, then unregister this committee,
  or retire the exchange.
evidence_level: source
checks:
- id: c1
  source: '0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446'
  file: Committee.sol
  line: 76
  has: address recovered = ecrecover(claimHash, v, r, s);
  says: Signers are recovered with ECDSA ecrecover over the claim hash.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: s-member
  source: '0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 79
  says: Each recovered signer must be a committee member.
  for:
  - evidence-2
  - justification
  - what
- id: s-fact
  source: '0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 83
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
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This committee registers a data availability fact for a StarkEx state update when enough ECDSA signatures recover to members. A quantum attacker who forges member signatures, with the operator key, could get a state with withheld data accepted and lock users' exits.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446#code) recovers each signer with ecrecover over the claim hash.
- [verifyAvailabilityProof](https://etherscan.io/address/0x4f8b2dd49d958b6ac3e5f4705bf1a9ada5bc4446#code) requires each recovered address to be a member, then registers the fact.

## Reviewer notes

### Mechanism

Committee.verifyAvailabilityProof(claimHash, availabilityProofs) (lines 60-84) checks the proof length. It then loops signaturesRequired times: it reads r, s, v (lines 72-74), calls ecrecover(claimHash, v, r, s) at line 76, and requires isMember[recovered] (line 79) and strictly increasing addresses (line 80). After the loop it calls registerFact(claimHash) (line 83). Per kev, the StarkExchange's operator-only updateState requires this fact alongside a STARK fact, so balances cannot be falsified. Forged member signatures plus the operator's ECDSA key would let a state whose data nobody holds be committed. Users then could not build the Merkle proofs the escape hatch needs, which locks funds. FinalizableCommittee lets the admin add members and increment signers before finalize (lines 39-51); members cannot be removed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: False balances: state transitions are STARK-proven.
- Ruled out: Contract upgrade fix: the committee is not upgradeable.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
