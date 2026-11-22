---
id: committee-1e601435-starkex-dac-signers
format: 2
title: Myria StarkEx data committee accepts ECDSA attestations quantum attackers forge
status: confirmed
severity: LOW
justification: Forged attestations could hide batch data, but the exchange is frozen; Myria's governor must swap
  verifiers first
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1e601435e181423e7a8430813d7500012a6169cb'
  name: Committee
  project: myria
  code: verified
  code_url: https://etherscan.io/address/0x1e601435e181423e7a8430813d7500012a6169cb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Register a post-quantum availability verifier before resuming state updates on the exchange
evidence_level: source
checks:
- id: c1
  source: '0x1e601435e181423e7a8430813d7500012a6169cb'
  file: Committee.sol
  line: 76
  has: address recovered = ecrecover(claimHash, v, r, s);
  says: Signers are recovered with ECDSA ecrecover over the claim hash.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x1e601435e181423e7a8430813d7500012a6169cb'
  file: Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 79
  says: Recovered signer must be a committee member.
  for:
  - evidence-2
  - what
- id: c3
  source: '0x1e601435e181423e7a8430813d7500012a6169cb'
  file: Committee.sol
  has: registerFact(claimHash);
  line: 83
  says: The claim hash is registered as a fact after signature checks.
  for:
  - evidence-3
  - what
- id: c4
  source: '0x1e601435e181423e7a8430813d7500012a6169cb'
  file: Committee.sol
  has: signaturesRequired = numSignaturesRequired;
  line: 40
  says: Threshold is set only in the constructor; fixing needs a new verifier.
  for:
  - action
  - justification
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

This committee registers a data availability fact for a claim hash once enough member ECDSA signatures recover to committee members. A quantum attacker who derives member keys could attest to data that is withheld, with the operator key also needed to use it.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x1e601435e181423e7a8430813d7500012a6169cb#code) recovers each signer with ecrecover over the claim hash.
- [verifyAvailabilityProof](https://etherscan.io/address/0x1e601435e181423e7a8430813d7500012a6169cb#code) requires each recovered address to be a committee member.
- [verifyAvailabilityProof](https://etherscan.io/address/0x1e601435e181423e7a8430813d7500012a6169cb#code) registers the claim hash as a fact after the signature loop.

## Reviewer notes

### Mechanism

verifyAvailabilityProof (lines 60-84) requires signaturesRequired 65-byte (r,s,v) entries (line 65). For each, ecrecover(claimHash, v, r, s) at line 76 must be a member (line 79) and addresses must be strictly increasing (line 80); then registerFact(claimHash) at line 83. Members and threshold are set only in the constructor (lines 31-41); there are no admin functions. StarkExchange updateState consumes this fact alongside a STARK fact, so forged attestations (plus the operator key) only enable withholding data, locking users out of the escape hatch. The exchange is currently frozen.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A false state transition cannot be proven: STARK proofs are still required.
- Ruled out: The committee itself holds no funds.

### History

- 2026-11-17: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
