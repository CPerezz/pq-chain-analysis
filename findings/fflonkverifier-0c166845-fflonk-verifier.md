---
id: fflonkverifier-0c166845-fflonk-verifier
format: 2
title: AliceNet's retired fflonk verifier accepts proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum attacker with the setup trapdoor; AliceNet's timelock can
  switch verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26'
  name: FflonkVerifier
  project: alicenet
  code: verified
  code_url: https://etherscan.io/address/0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Mark rollup type 1 obsolete and move the rollup to a type with a hash-based verifier via the timelock.
evidence_level: source
checks:
- id: c1
  source: '0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 162
  has: function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool)
    {
  says: verifyProof entry point takes the proof and one public signal
  for:
  - evidence-1
  - what
- id: c7
  source: '0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1199
  has: let success := staticcall(sub(gas(), 2000), 8, mIn, 384, mIn, 0x20)
  says: validity comes from the BN254 pairing precompile call
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
  who: Review17 (on-chain reads of the rollup manager, rollup and bridge)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks AliceNet validium state proofs with an fflonk pairing check on BN254. A quantum attacker who recovers the setup trapdoor could make it accept a proof of a false state transition.

## Evidence

- [verifyProof](https://etherscan.io/address/0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26#code) takes a 24-word proof and one public signal and returns a bool.
- [checkPairing](https://etherscan.io/address/0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26#code) decides validity with the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

verifyProof (line 162) runs checkInput, computeChallenges(pMem, pubSignals), the inversions, Lagrange and PI evaluations, computeR0/R1/R2 and computeFEJ, which build [F]_1, [E]_1 and [J]_1 with the ecAdd (precompile 6, lines 1074, 1100, 1126) and ecMul (precompile 7, lines 1090, 1116) calls. checkPairing (lines 1164-1202) forms F - E - J + y*W2 and calls the BN254 pairing precompile 8 at line 1199 against the setup points X2; isOk is the result. Soundness rests on the fflonk setup's discrete log; with the trapdoor any public signal can be proven. The rollup manager uses this verifier for rollup type 1, whose accepted proofs update the exit root that the AliceNet bridge pays claims against.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rollup type 1 is no longer used by the live rollup; the live verifier is a separate contract.
- Ruled out: The contract is not upgradeable; the fix is in the rollup manager's configuration.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
