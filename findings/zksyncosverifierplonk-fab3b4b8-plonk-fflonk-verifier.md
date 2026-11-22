---
id: zksyncosverifierplonk-fab3b4b8-plonk-fflonk-verifier
format: 2
title: ZKsync OS PLONK verifier rests on BN254 pairings a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: A forged batch proof passes the pairing check; ZKsync governance can repoint chains to a new verifier,
  no Ethereum fork.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  name: ZKsyncOSVerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 PLONK wrapper with an on-chain hash-based STARK/FRI verifier of the underlying proof.
evidence_level: source
checks:
- id: c1
  source: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: pointMulIntoDest calls the BN254 ecMul precompile (address 7).
  for:
  - what
- id: c2
  source: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: pointAddIntoDest calls the BN254 ecAdd precompile (address 6).
  for:
  - what
- id: c5
  source: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: pointMulAndAddIntoDest calls ecMul.
  for:
  - evidence-2
- id: c6
  source: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: pointMulAndAddIntoDest then calls ecAdd.
  for:
  - evidence-2
- id: c7
  source: '0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: finalPairing calls the BN254 pairing precompile (address 8).
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

This contract verifies ZKsync OS batch proofs as a PLONK SNARK over BN254, using ecMul, ecAdd and a final pairing check. It accepts a proof once the pairing holds, so a quantum attacker with the setup trapdoor can make a false proof pass.

## Evidence

- [finalPairing](https://etherscan.io/address/0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1#code) calls the BN254 pairing precompile and reverts unless it returns true.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0xfab3b4b8d97bbce61f2440ff15dc783bbd881db1#code) combines proof points with the ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verifier's assembly runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and then finalPairing (lines 1688-1703). Before finalPairing it combines proof points with the precompiles: ecMul at address 7 in pointMulIntoDest (line 394), and ecAdd at address 6 in pointAddIntoDest, pointSubAssign and pointAddAssign (lines 405, 416, 427). pointMulAndAddIntoDest uses both (lines 437, 441). finalPairing (line 1673) calls the pairing precompile at address 8 against the fixed G2 elements and reverts unless the result is true. After that it returns true. Soundness therefore rests on the KZG/BN254 trusted setup. Someone who knows the trapdoor, which a quantum computer can recover from the published setup, can build a proof for a false batch that satisfies this check. In kev's census, this contract was the plonk leg for chain 30715 behind ZKsyncOSDualVerifier 0x5b4b58a5…. No registered chain points at it now.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read.
- Ruled out: Holds about $0 and had no calls in the 30-day window.
- Ruled out: Retired in kev's census: no registered chain points at it now, so nothing is exposed through it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
