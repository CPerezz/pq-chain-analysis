---
id: committee-879cd579-starkex-dac-signers
format: 2
title: Sorare StarkEx committee takes ECDSA attestations a quantum attacker can forge
status: confirmed
severity: LOW
justification: Forged quorum plus operator key could hide batch data; LOW as exchange is frozen; Sorare's governor
  can swap verifier
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x879cd57975d596004863d30c59d579ef78bbbe32'
  name: Committee
  project: sorare
  code: verified
  code_url: https://etherscan.io/address/0x879cd57975d596004863d30c59d579ef78bbbe32#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Before resuming updates, register an availability verifier with post-quantum member signatures or move data
  on-chain
evidence_level: source
checks:
- id: c1
  source: '0x879cd57975d596004863d30c59d579ef78bbbe32'
  file: Committee.sol
  line: 82
  has: address recovered = ecrecover(
  says: Each attestation signer is recovered with ECDSA ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c-member
  source: '0x879cd57975d596004863d30c59d579ef78bbbe32'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 90
  says: Recovered signer must be a committee member.
  for:
  - evidence-1
  - justification
  - what
- id: c-fact
  source: '0x879cd57975d596004863d30c59d579ef78bbbe32'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 94
  says: Valid quorum registers the claim as a fact.
  for:
  - what
- id: c-ctor
  source: '0x879cd57975d596004863d30c59d579ef78bbbe32'
  file: Committee.sol
  has: signaturesRequired = numSignaturesRequired;
  line: 42
  says: Threshold is set in the constructor.
  for:
  - action
  - evidence-2
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

This committee registers a data availability fact once a quorum of member ECDSA signatures over the claim hash recovers to members. A quantum attacker with member keys could forge that quorum, letting a state with withheld data through and locking users out of exits.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x879cd57975d596004863d30c59d579ef78bbbe32#code) recovers each signer with ecrecover and requires a committee member.
- [Committee](https://etherscan.io/address/0x879cd57975d596004863d30c59d579ef78bbbe32#code) sets members and threshold only in its constructor.

## Reviewer notes

### Mechanism

verifyAvailabilityProof(claimHash, availabilityProofs) (lines 65-95) checks the proof length, then for each of signaturesRequired 65-byte (r,s,v) entries calls ecrecover(claimHash, v, r, s) at line 82, requires isMember[recovered] (line 90) and strictly increasing addresses (line 91), then registerFact(claimHash) (line 94). Members and threshold are set in the constructor (lines 32-43); there are no admin functions. The StarkExchange's operator-only updateState requires this fact alongside the STARK fact, so forging needs member keys and the operator key and can only withhold data, not prove a false state. The exchange is frozen, so no update can currently use attestations.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The committee holds no funds.
- Ruled out: A false state cannot be proven: transitions are STARK-verified.
- Ruled out: Members and threshold cannot be changed: no admin functions.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
