---
id: committee-16ba0f22-immutablex-starkex-dac-signers
format: 2
title: ImmutableX DA committee attests with ECDSA keys a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'LOW: forged attestations need the operator key too, and the exchange no longer accepts state updates;
  Immutable governs.'
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295'
  name: Committee
  project: immutable
  code: verified
  code_url: https://etherscan.io/address/0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: If state updates resume, register an availability verifier with post-quantum member signatures or move data
  on-chain.
evidence_level: source
checks:
- id: c1
  source: '0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295'
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
  source: '0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 88
  says: Recovered signer must be a committee member.
  for:
  - evidence-1
  - justification
  - what
- id: c92
  source: '0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 92
  says: Claim is registered as a fact after signatures pass.
  for:
  - evidence-2
  - what
- id: c40
  source: '0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295'
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

This committee registers a batch's availability claim once enough member ECDSA signatures recover to member addresses. A quantum attacker with member keys forges a quorum, which with the operator key lets a state with withheld data through, locking users out.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295#code) recovers each signer with ecrecover and requires committee membership.
- [verifyAvailabilityProof](https://etherscan.io/address/0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295#code) registers the claim hash as a fact after the signature loop.
- [constructor](https://etherscan.io/address/0x16ba0f221664a5189cf2c1a7af0d3abfc70aa295#code) fixes members and the signature threshold at deployment.

## Reviewer notes

### Mechanism

verifyAvailabilityProof(claimHash, availabilityProofs) (lines 63-93) loops signaturesRequired times over 65-byte (r,s,v) entries, calls ecrecover(claimHash, v, r, s) at line 80, requires isMember[recovered] (line 88) and strictly increasing addresses (line 89), then registerFact(claimHash) (line 92). The StarkExchange's updateState consumed this fact alongside a STARK proof fact, so forged attestations could only admit a valid state whose data is withheld, and only with the operator key. Members and threshold are set in the constructor (lines 32-41) with no admin functions. Per kev, the exchange now runs a migration implementation without updateState, so the facts release or lock nothing today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A false state transition cannot be proven: transitions are STARK-proven.
- Ruled out: The committee holds no funds.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
