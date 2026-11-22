---
id: l1verifierplonk-ad36ffc4-plonk-fflonk-verifier
format: 2
title: ZKsync L1VerifierPlonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 PLONK falls to a quantum attacker; ZKsync governance can repoint chains to new verifiers, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xad36ffc4066855aef3bdf6bf03ca427bb084636e'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xad36ffc4066855aef3bdf6bf03ca427bb084636e#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with an on-chain hash-based STARK/FRI verifier and repoint chains through a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xad36ffc4066855aef3bdf6bf03ca427bb084636e'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile used for point multiplication
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0xad36ffc4066855aef3bdf6bf03ca427bb084636e'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile used for point addition
  for:
  - what
- id: c7
  source: '0xad36ffc4066855aef3bdf6bf03ca427bb084636e'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: final BN254 pairing precompile decides proof acceptance
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

This contract checks ZK Stack batch proofs with BN254 PLONK, using elliptic-curve multiply, add and a final pairing check. With the setup trapdoor a quantum attacker could build a proof that passes the pairing check for a false batch. No registered chain uses this verifier now.

## Evidence

- [finalPairing](https://etherscan.io/address/0xad36ffc4066855aef3bdf6bf03ca427bb084636e#code) accepts the proof based on the BN254 pairing precompile.
- [pointMulIntoDest](https://etherscan.io/address/0xad36ffc4066855aef3bdf6bf03ca427bb084636e#code) builds commitments with the BN254 ecMul precompile.

## Reviewer notes

### Mechanism

Verification runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing. The commitment arithmetic uses ecMul (precompile 7, line 394) and ecAdd (precompile 6, lines 405, 416, 427 and 441). finalPairing calls the pairing precompile 8 at line 1673 and reverts unless it returns true. Soundness rests on the BN254 trusted setup; a discrete-log break yields the trapdoor, so a quantum attacker could forge a passing proof. The contract was used by ZERO Network and Memento via DualVerifier 0x079004d9; that use is now retired.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No registered chain points at this verifier now, so nothing is exposed through it.
- Ruled out: The contract holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
