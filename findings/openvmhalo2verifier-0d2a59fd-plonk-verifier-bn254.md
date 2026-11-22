---
id: openvmhalo2verifier-0d2a59fd-plonk-verifier-bn254
format: 2
title: Scroll Halo2 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 KZG trapdoor lets a forged bundle proof pass; Scroll's timelocked owner can register a hash-based
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  name: OpenVmHalo2Verifier
  project: scroll
  code: verified
  code_url: https://etherscan.io/address/0x0d2a59fd7060460f07c30c2817b4e79576da01c6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 869
impact: funds-loss
action: Deploy a hash-based verifier and have the Scroll owner register it in the rollup verifier via updateVerifier.
evidence_level: source
checks:
- id: c1
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/Halo2Verifier.sol
  line: 2120
  has: success := and(eq(staticcall(gas(), 0x8, 0x64a0, 0x180, 0x64a0, 0x20), 1), success)
  says: final BN254 pairing precompile (0x8) call
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/Halo2Verifier.sol
  line: 1910
  has: success := and(eq(staticcall(gas(), 0x7, 0x50c0, 0x60, 0x50c0, 0x40), 1), success)
  says: BN254 ecmul precompile call in MSM
  for:
  - evidence-3
- id: c3
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/Halo2Verifier.sol
  line: 1915
  has: success := and(eq(staticcall(gas(), 0x6, 0x5120, 0x80, 0x5120, 0x40), 1), success)
  says: BN254 ecadd precompile call in MSM
  for:
  - evidence-3
- id: v-verify
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/OpenVmHalo2Verifier.sol
  has: function verify(bytes calldata publicValues, bytes calldata proofData, bytes32 appExeCommit, bytes32 appVmCommit)
  line: 61
  says: verify entry point taking public values, proof and commits
  for:
  - action
  - evidence-1
  - justification
  - what
- id: v-self
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/OpenVmHalo2Verifier.sol
  has: if iszero(staticcall(gas(), address(), proofPtr, fullProofLength, 0, 0))
  line: 98
  says: verify self-calls the Halo2 fallback
  for:
  - evidence-1
- id: v-pv
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/OpenVmHalo2Verifier.sol
  has: MemoryPointer proofPtr = _constructProof(publicValues, proofData, appExeCommit, appVmCommit);
  line: 91
  says: public values are bound into the proof
  for:
  - what
- id: c1b
  source: '0x0d2a59fd7060460f07c30c2817b4e79576da01c6'
  file: src/v2.0-deferral/Halo2Verifier.sol
  has: success := and(eq(mload(0x64a0), 1), success)
  line: 2121
  says: acceptance requires the pairing result to equal 1
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
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x9f66505c
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (0x9f66505c deployer, wrapper and caller trace; Scroll verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review14 (verified source of the current verifier, verifier registry and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x39854df3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review01 (0x39854df3 creator, last caller trace, bytecode constants, verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Scroll bundle proofs with a Halo2/KZG verifier on BN254, accepting a proof when the final pairing check passes. A quantum attacker who recovers the setup trapdoor can forge a passing proof for false public values.

## Evidence

- [verify](https://etherscan.io/address/0x0d2a59fd7060460f07c30c2817b4e79576da01c6#code) packs the public values and commits into the proof and self-calls the Halo2 fallback.
- [The fallback](https://etherscan.io/address/0x0d2a59fd7060460f07c30c2817b4e79576da01c6#code) ends with a BN254 pairing precompile call that decides success.
- [The fallback](https://etherscan.io/address/0x0d2a59fd7060460f07c30c2817b4e79576da01c6#code) builds KZG commitments with BN254 ecmul and ecadd precompile calls.

## Reviewer notes

### Mechanism

OpenVmHalo2Verifier.verify (OpenVmHalo2Verifier.sol line 61) checks lengths and field ranges. It builds the proof with _constructProof (accumulator, appExeCommit, appVmCommit, 32 public-value bytes, suffix) and self-calls at line 98 into the snark-verifier Halo2Verifier fallback. The fallback computes MSMs with precompiles 0x7/0x6 (Halo2Verifier.sol lines 1910-1937) and runs the final BN254 pairing at line 2120. It requires result 1 at line 2121 and otherwise reverts at line 2124. Per kev's finding, ScrollChain reaches this contract through MultipleVersionRollupVerifier (version 10) and finalizes withdraw roots once it accepts a proof. A trapdoor-forged KZG opening passes this pairing check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: The contract is not upgradeable; the fix is repointing in MultipleVersionRollupVerifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
