---
id: zksyncosverifierfflonk-f6b3708b-zk-verifiers
format: 2
title: ADI Chain fflonk verifier trusts a BN254 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs are forgeable with the setup trapdoor; MEDIUM as ADI governance can swap verifiers
  by config.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a'
  name: ZKsyncOSVerifierFflonk
  project: adi-chain
  code: verified
  code_url: https://etherscan.io/address/0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a post-quantum ZKsync OS verifier in the dual verifier and remove the BN254 legs.
evidence_level: source
checks:
- id: c1
  source: '0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul calls the BN254 ecMul precompile (7).
  for:
  - evidence-2
  - what
- id: c2
  source: '0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add calls the BN254 ecAdd precompile (6).
  for:
  - evidence-2
  - what
- id: c4
  source: '0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check calls the BN254 pairing precompile (8).
  for:
  - action
  - evidence-1
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks ADI Chain fflonk batch proofs with BN254 elliptic-curve and pairing precompiles. A quantum attacker who recovers the setup trapdoor could make a false proof pass the pairing check.

## Evidence

- [pairing_check](https://etherscan.io/address/0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a#code) decides validity with the BN254 pairing precompile.
- [point_mul](https://etherscan.io/address/0xf6b3708be4192ce4526c2f87d4c3eaba79230e6a#code) and point_add use the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

ZKsyncOSVerifierFflonk is registered as the fflonk leg (version 0) in ADI Chain's ZKsyncOSDualVerifier. Its verification builds commitments with point_mul (ecMul, precompile 7, line 1501), point_add/point_sub (ecAdd, precompile 6, lines 1520, 1541), modexp (precompile 5, line 1614) and ends in pairing_check (ecPairing, precompile 8, line 1576) against fixed VK G2 elements. Soundness rests on the BN254 KZG setup; with the trapdoor a false batch proof passes. Per kev, the dual verifier's verify() routes no proof type to the fflonk leg, so this contract is registered but not currently reachable; the live risk is through the plonk leg, and governance can change either via addVerifier/removeVerifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin.
- Ruled out: Holds no value itself.
- Ruled out: Not currently routed to by the dual verifier's verify().

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
