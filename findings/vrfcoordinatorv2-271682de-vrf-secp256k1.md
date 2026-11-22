---
id: vrfcoordinatorv2-271682de-vrf-secp256k1
format: 2
title: Chainlink VRFCoordinatorV2 lets a quantum attacker predict VRF randomness early
status: confirmed
severity: MEDIUM
justification: ECVRF proofs rest on secp256k1 keys; MEDIUM as Chainlink must deploy a post-quantum VRF coordinator
  and consumers move
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x271682deb8c4e0901d1a1550ad2e64d568e69909'
  name: VRFCoordinatorV2
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0x271682deb8c4e0901d1a1550ad2e64d568e69909#code
  copies: 1
  upgradeable: 'no'
  admin: '0x463219821e151c0c44364c27833e39386c48e64f'
value:
  usd: 575100
  basis: held
activity:
  txs_90d: 31
impact: funds-loss
action: Deploy a coordinator that verifies a post-quantum VRF and move V2 consumers and subscriptions to it
evidence_level: source
checks:
- id: c3
  source: '0x271682deb8c4e0901d1a1550ad2e64d568e69909'
  file: src/v0.8/VRF.sol
  line: 274
  has: address actual = ecrecover(bytes32(0), v, bytes32(x), scalarTimesX);
  says: VRF proof check uses ecrecover for secp256k1 scalar multiplication
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x271682deb8c4e0901d1a1550ad2e64d568e69909'
  file: src/v0.8/VRF.sol
  line: 439
  has: address computed = ecrecover(pseudoHash, v, bytes32(p[0]), pseudoSignature);
  says: VRF proof check uses ecrecover to verify c*p+s*g on secp256k1
  for:
  - action
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
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

VRFCoordinatorV2 accepts random words only with an ECVRF proof on secp256k1, checked with ecrecover-based curve arithmetic. A quantum attacker who recovers an oracle's proving key computes pending requests' random words before fulfilment and beats consumers' games and draws.

## Evidence

- [ecmulVerify](https://etherscan.io/address/0x271682deb8c4e0901d1a1550ad2e64d568e69909#code) uses ecrecover to check secp256k1 scalar multiplication in the VRF proof.
- [verifyLinearCombinationWithGenerator](https://etherscan.io/address/0x271682deb8c4e0901d1a1550ad2e64d568e69909#code) checks c*p+s*g on secp256k1 via ecrecover.

## Reviewer notes

### Mechanism

fulfillRandomWords (V2, line 556) has no caller restriction and calls getRandomnessFromProof: the proving key must be registered in s_provingKeys, the request commitment must match, the seed is mixed with the request block hash, and VRF._randomValueFromVRFProof verifies the ECVRF proof on secp256k1. VRF.sol ecmulVerify (line 274) and verifyLinearCombinationWithGenerator (line 439) use ecrecover as a scalar-multiplication gadget. The proving public key is on-chain, so Shor recovers the secret; the attacker then computes the unique output for any pending request once its block hash is known, ahead of the oracle. Output is predicted, not chosen. Rotating to another secp256k1 key via registerProvingKey does not help.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Subscription LINK/ETH balances held by the coordinator are not redirected by a forged proof
- Ruled out: Attacker cannot choose the random value, only learn it early

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
