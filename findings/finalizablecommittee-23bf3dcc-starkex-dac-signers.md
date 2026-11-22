---
id: finalizablecommittee-23bf3dcc-starkex-dac-signers
format: 2
title: edgeX v1 availability committee accepts quantum-forgeable ECDSA attestations
status: confirmed
severity: LOW
justification: Forged signatures could attest unavailable data; LOW as the StarkPerpetual is frozen. edgeX governance
  fixes.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x23bf3dcc14680162b7f5355aabb56d31823c946e'
  name: FinalizableCommittee
  project: edgex
  code: verified
  code_url: https://etherscan.io/address/0x23bf3dcc14680162b7f5355aabb56d31823c946e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Before any unfreeze, register an availability verifier using post-quantum member signatures, or move data
  on-chain.
evidence_level: source
checks:
- id: c1
  source: '0x23bf3dcc14680162b7f5355aabb56d31823c946e'
  file: starkware/solidity/committee/Committee.sol
  line: 77
  has: address recovered = ecrecover(claimHash, v, r, s);
  says: The signer is recovered with ECDSA ecrecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c-member
  source: '0x23bf3dcc14680162b7f5355aabb56d31823c946e'
  file: starkware/solidity/committee/Committee.sol
  has: require(isMember[recovered], "AVAILABILITY_PROVER_NOT_IN_COMMITTEE");
  line: 80
  says: Recovered signer must be a committee member.
  for:
  - evidence-1
  - justification
  - what
- id: c-loop
  source: '0x23bf3dcc14680162b7f5355aabb56d31823c946e'
  file: starkware/solidity/committee/Committee.sol
  has: for (uint256 proofIdx = 0; proofIdx < signaturesRequired; proofIdx++) {
  line: 72
  says: Checks signaturesRequired signatures.
  for:
  - evidence-2
  - what
- id: c-register
  source: '0x23bf3dcc14680162b7f5355aabb56d31823c946e'
  file: starkware/solidity/committee/Committee.sol
  has: registerFact(claimHash);
  line: 84
  says: Registers the claim as a fact after signatures pass.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
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

This committee registers a state-update fact once enough members sign the claim hash with ECDSA. A quantum attacker who derives members' keys could forge a quorum and, with the operator key, get a state accepted whose data nobody holds.

## Evidence

- [verifyAvailabilityProof](https://etherscan.io/address/0x23bf3dcc14680162b7f5355aabb56d31823c946e#code) recovers each signer with ecrecover and requires it to be a member.
- [verifyAvailabilityProof](https://etherscan.io/address/0x23bf3dcc14680162b7f5355aabb56d31823c946e#code) registers the claim hash as a fact after signaturesRequired signatures pass.

## Reviewer notes

### Mechanism

Committee.verifyAvailabilityProof(claimHash, availabilityProofs) (Committee.sol lines 61-85) checks the proof length (line 66), then loops proofIdx < signaturesRequired (line 72), reading 65-byte r, s, v (lines 73-75) and calling ecrecover(claimHash, v, r, s) (line 77). Each recovered address must satisfy isMember (line 80) and be strictly increasing (line 81). It then calls registerFact(claimHash) (line 84). StarkPerpetual's operator-only updateState requires this fact from a registered availability verifier together with a STARK fact, so forged attestations cannot create an invalid state but could enable data withholding that blocks escape-hatch withdrawals. FinalizableCommittee lets the admin add members and raise the threshold until finalized (lines 39-51). Kev's on-chain reads show StarkPerpetual is frozen, so updateState reverts and the path is dormant.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forged attestations cannot produce an invalid state: transitions are STARK-proven.
- Ruled out: The committee holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
