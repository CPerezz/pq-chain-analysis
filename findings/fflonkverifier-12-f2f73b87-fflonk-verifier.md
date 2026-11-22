---
id: fflonkverifier-12-f2f73b87-fflonk-verifier
format: 2
title: AliceNet's fflonk BN254 verifier accepts state proofs a quantum attacker forges
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum attacker; AliceNet's timelock can switch the rollup to a hash-based
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  name: FflonkVerifier_12
  project: alicenet
  code: verified
  code_url: https://etherscan.io/address/0xf2f73b87e97730dca6558dd71c0b1c945ca38096#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 52
impact: funds-loss
action: Add a rollup type with a hash-based (STARK/FRI) verifier via the timelock and update the AliceNet rollup
  to it.
evidence_level: source
checks:
- id: c1
  source: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 186
  has: function verifyProof(
  says: verifyProof is the public proof-check entry point.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1918
  has: let success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: g1_acc calls the BN254 ecAdd precompile (6).
  for:
  - evidence-3
  - what
- id: c3
  source: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1934
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: g1_mulAcc calls the BN254 ecMul precompile (7) on proof points.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1944
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: g1_mulAcc accumulates via ecAdd (6).
  for:
  - justification
  - what
- id: c6
  source: '0xf2f73b87e97730dca6558dd71c0b1c945ca38096'
  file: contracts/verifiers/FflonkVerifier_12.sol
  line: 1970
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: g1_mulAccC accumulates via ecAdd (6).
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (on-chain reads of the rollup manager, rollup and bridge)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks AliceNet validium state proofs with fflonk over BN254, using the elliptic-curve precompiles. With the setup trapdoor a quantum attacker could make it accept a false state transition, letting the rollup's bridge pay out on a forged exit root.

## Evidence

- [verifyProof](https://etherscan.io/address/0xf2f73b87e97730dca6558dd71c0b1c945ca38096#code) takes a 24-word proof and one public signal and returns a bool.
- [g1_mulAcc](https://etherscan.io/address/0xf2f73b87e97730dca6558dd71c0b1c945ca38096#code) calls the BN254 scalar-multiplication precompile (address 7) on proof points.
- [g1_acc](https://etherscan.io/address/0xf2f73b87e97730dca6558dd71c0b1c945ca38096#code) calls the BN254 point-addition precompile (address 6).

## Reviewer notes

### Mechanism

verifyProof(bytes32[24] proof, uint256[1] pubSignals) (line 186) runs in assembly: it computes inverses, the r0/r1/r2 evaluations, then computeFEJ (line 1978) accumulates [F]_1, [E]_1, [J]_1 using g1_acc (ecAdd, line 1918), g1_mulAcc (ecMul line 1934, ecAdd line 1944) and g1_mulAccC (lines 1960, 1970), and ends in a BN254 pairing check against the fflonk setup. In AliceNet's rollup manager, verifyBatchesTrustedAggregator passes the hash of the new state and exit roots as the public signal; an accepted proof updates the exit root the bridge uses for claimAsset. Knowing the setup trapdoor (recoverable by discrete log on a quantum computer) lets an attacker build a passing proof for a false root. The verifier is fixed per rollup type; the timelock can add a new rollup type and move the rollup.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable; the fix is repointing the rollup, not changing this code.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
