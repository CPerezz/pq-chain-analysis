---
id: committee-28780349-rhinofi-starkex-dac-signers
format: 2
title: rhino.fi StarkEx DAC takes ECDSA attestations a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged quorum plus operator key could hide batch data; rhino.fi governance can swap the verifier,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x28780349a33eee56bb92241baab8095449e24306'
  name: Committee
  project: rhino-fi
  code: verified
  code_url: https://etherscan.io/address/0x28780349a33eee56bb92241baab8095449e24306#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Before resuming state updates, register an availability verifier with post-quantum member signatures, or
  move data on-chain.
evidence_level: source
checks:
- id: c1
  source: '0x28780349a33eee56bb92241baab8095449e24306'
  file: Committee.sol
  line: 80
  has: address recovered = ecrecover(
  says: Signers are recovered with ECDSA ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c88
  source: '0x28780349a33eee56bb92241baab8095449e24306'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 88
  says: Recovered signer must be a committee member.
  for:
  - evidence-2
  - justification
  - what
- id: c92
  source: '0x28780349a33eee56bb92241baab8095449e24306'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 92
  says: A valid quorum registers the claim as a fact.
  for:
  - evidence-2
  - justification
  - what
- id: c38
  source: '0x28780349a33eee56bb92241baab8095449e24306'
  file: Committee.sol
  has: isMember[committeeMembers[idx]] = true;
  line: 38
  says: Members are set in the constructor.
  for:
  - evidence-3
- id: c40
  source: '0x28780349a33eee56bb92241baab8095449e24306'
  file: Committee.sol
  has: signaturesRequired = numSignaturesRequired;
  line: 40
  says: Threshold is set in the constructor.
  for:
  - evidence-3
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

This contract is the data availability committee for rhino.fi's StarkEx exchange and registers a batch claim as a fact once enough member ECDSA signatures recover to committee members. A quantum attacker who derives member keys could forge that quorum, letting a state with withheld data through.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x28780349a33eee56bb92241baab8095449e24306#code) recovers each signer with ecrecover over the claim hash.
- [verifyAvailabilityProof](https://etherscan.io/address/0x28780349a33eee56bb92241baab8095449e24306#code) requires each recovered address to be a committee member, then registers the fact.
- [The constructor](https://etherscan.io/address/0x28780349a33eee56bb92241baab8095449e24306#code) fixes members and the signature threshold at deployment.

## Reviewer notes

### Mechanism

verifyAvailabilityProof(claimHash, availabilityProofs) (lines 63-93) checks the proof length against signaturesRequired * 65, then loops signaturesRequired times: it reads r, s, v (lines 76-78), calls ecrecover(claimHash, v, r, s) (line 80), requires isMember[recovered] (line 88) and strictly increasing addresses (line 89), then registerFact(claimHash) (line 92). The StarkExchange's operator-only updateState requires this fact plus the STARK fact. So forged attestations, which also need the operator key, can only admit a state whose data is withheld; they cannot prove a false state. Members and threshold are set in the constructor (lines 32-41). There are no admin functions. The exchange's implementation has been replaced, and it holds nothing today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged quorum cannot prove a false state; transitions are STARK-proven.
- Ruled out: The committee has no admin functions to change members or threshold.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
