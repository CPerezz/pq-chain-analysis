---
id: zksyncosverifierplonk-c1288a84-zk-verifiers
format: 2
title: ADI Chain PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum attacker; MEDIUM as ADI governance can register a new verifier
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  name: ZKsyncOSVerifierPlonk
  project: adi-chain
  code: verified
  code_url: https://etherscan.io/address/0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2766
impact: funds-loss
action: Register a post-quantum verifier in the dual verifier and remove this BN254 PLONK leg
evidence_level: source
checks:
- id: c1
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: ecMul precompile 7 used for point multiplication
  for:
  - what
- id: c2
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: ecAdd precompile 6 used for point addition
  for:
  - what
- id: c5
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: ecMul inside pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c6
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: ecAdd inside pointMulAndAddIntoDest
  for:
  - evidence-2
- id: c7
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: BN254 pairing precompile 8 called in finalPairing
  for:
  - action
  - evidence-1
  - justification
  - what
- id: fin
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  has: if iszero(mload(0)) {
  line: 1677
  says: proof is rejected when the pairing check fails
  for:
  - evidence-1
  - what
- id: ret
  source: '0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9'
  file: contracts/state-transition/verifiers/ZKsyncOSVerifierPlonk.sol
  has: mstore(0, true)
  line: 1705
  says: verifier returns true after finalPairing passes
  for:
  - evidence-3
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

This contract checks ADI Chain batch proofs with a PLONK pairing check over BN254 using the ecMul, ecAdd and ecPairing precompiles. With the setup trapdoor, a quantum attacker could make a false proof pass this final pairing check.

## Evidence

- [finalPairing](https://etherscan.io/address/0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9#code) calls the BN254 pairing precompile and accepts the proof when the pairing holds.
- [pointMulAndAddIntoDest](https://etherscan.io/address/0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9#code) builds the pairing inputs with BN254 ecMul and ecAdd.
- [verification](https://etherscan.io/address/0xc1288a84c5b2c93ed4bf712ff4bb96d862b32aa9#code) returns true after finalPairing succeeds.

## Reviewer notes

### Mechanism

The verification body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries, prepareAggregatedCommitment and finalPairing (lines 1688-1703), then returns true (line 1705). Point operations use ecMul (precompile 7, lines 394, 437) and ecAdd (precompile 6, lines 405, 416, 427, 441). finalPairing calls the pairing precompile 8 at line 1673 and reverts on failure at line 1677. Soundness rests on the BN254 KZG setup; a quantum attacker who recovers the trapdoor can produce a proof that passes. Per kev, ZKsyncOSDualVerifier routes type-2 proofs at version 0 here, and verified batches release withdrawals from ADI Chain's L1 vault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy; the fix is in the dual verifier's configuration

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
