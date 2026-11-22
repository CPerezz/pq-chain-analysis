---
id: vrfcoordinatorv2-5-d7f86b4b-vrf-secp256k1
format: 2
title: Chainlink VRF v2.5 randomness can be predicted by a quantum attacker
status: confirmed
severity: MEDIUM
justification: A recovered secp256k1 proving key reveals randomness early; Chainlink must deploy a post-quantum
  VRF coordinator.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd7f86b4b8cae7d942340ff628f82735b7a20893a'
  name: VRFCoordinatorV2_5
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0xd7f86b4b8cae7d942340ff628f82735b7a20893a#code
  copies: 1
  upgradeable: 'no'
  admin: '0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d'
value:
  usd: 517564
  basis: held
activity:
  txs_90d: 240466
impact: funds-loss
action: Deploy a coordinator with a post-quantum VRF and move subscriptions there with migrate.
evidence_level: source
checks:
- id: c1
  source: '0xd7f86b4b8cae7d942340ff628f82735b7a20893a'
  file: src/v0.8/vrf/VRF.sol
  line: 280
  has: address actual = ecrecover(bytes32(0), v, bytes32(x), scalarTimesX);
  says: ecrecover is used to verify secp256k1 scalar multiplication in the VRF proof.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xd7f86b4b8cae7d942340ff628f82735b7a20893a'
  file: src/v0.8/vrf/VRF.sol
  line: 442
  has: address computed = ecrecover(pseudoHash, v, bytes32(p[0]), pseudoSignature);
  says: ecrecover is used to verify the linear combination c*p+s*g in the VRF proof.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xd7f86b4b8cae7d942340ff628f82735b7a20893a'
  file: src/v0.8/shared/access/ConfirmedOwnerWithProposal.sol
  line: 26
  has: function transferOwnership(address to) public override onlyOwner {
  says: Ownership transfer is restricted to the current owner.
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The coordinator accepts random values only with an ECVRF proof on secp256k1, checked through ecrecover. A quantum attacker who recovers an oracle's proving key computes the random words of pending requests before fulfilment and beats consumers that pay out on them.

## Evidence

- [_ecmulVerify](https://etherscan.io/address/0xd7f86b4b8cae7d942340ff628f82735b7a20893a#code) checks secp256k1 scalar multiplication with ecrecover.
- [_verifyLinearCombinationWithGenerator](https://etherscan.io/address/0xd7f86b4b8cae7d942340ff628f82735b7a20893a#code) verifies the proof's c*p+s*g term with ecrecover.
- [transferOwnership](https://etherscan.io/address/0xd7f86b4b8cae7d942340ff628f82735b7a20893a#code) is owner-only; the owner controls the coordinator's configuration.

## Reviewer notes

### Mechanism

fulfillRandomWords(proof, rc, onlyPremium) has no caller check and calls _getRandomnessFromProof, which requires a registered proving key (s_provingKeys), a matching request commitment, mixes the seed with the request block hash, and calls VRF._randomValueFromVRFProof. VRF.sol verifies the ECVRF proof on secp256k1 using ecrecover as a scalar-multiplication gadget (_ecmulVerify line 280, _verifyLinearCombinationWithGenerator line 442). The proving public key is on-chain; with the secret key from Shor, anyone computes the unique output for each pending request once the request block hash is known, ahead of the oracle. The output is predicted, not chosen. Rotating to another secp256k1 key via registerProvingKey does not help.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Subscription LINK/ETH balances are not redirected by a forged proof.
- Ruled out: The attacker cannot choose the random output, only predict it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
