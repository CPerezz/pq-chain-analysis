---
id: l1verifierplonk-2db2ffde-plonk-fflonk-verifier
format: 2
title: ZKsync PLONK verifier leg accepts batch proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 pairing proofs fall to a quantum setup-trapdoor attack; ZKsync governance can repoint chains
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  name: L1VerifierPlonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 PLONK wrapper with a hash-based STARK verifier through a ZKsync protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 394
  has: if iszero(staticcall(gas(), 7, 0, 0x60, dest, 0x40)) {
  says: Points are multiplied with the BN254 ecMul precompile (7).
  for:
  - evidence-2
  - justification
  - what
- id: c2
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 405
  has: if iszero(staticcall(gas(), 6, 0x00, 0x80, dest, 0x40)) {
  says: Points are added with the BN254 ecAdd precompile (6).
  for:
  - evidence-2
  - what
- id: c5
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 437
  has: let success := staticcall(gas(), 7, 0, 0x60, 0, 0x40)
  says: Multiply-and-add uses ecMul (7).
  for:
  - evidence-2
- id: c6
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 441
  has: success := and(success, staticcall(gas(), 6, 0x00, 0x80, dest, 0x40))
  says: Multiply-and-add uses ecAdd (6).
  for:
  - evidence-2
- id: c7
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  line: 1673
  has: let success := staticcall(gas(), 8, 0, 0x180, 0x00, 0x20)
  says: The final check calls the BN254 pairing precompile (8).
  for:
  - action
  - evidence-1
  - justification
  - what
- id: step6
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  has: finalPairing()
  line: 1703
  says: Verification ends with the final pairing check.
  for:
  - evidence-3
- id: ret
  source: '0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6'
  file: contracts/state-transition/verifiers/L1VerifierPlonk.sol
  has: mstore(0, true)
  line: 1705
  says: The verifier returns true once the pairing passes.
  for:
  - evidence-3
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

This contract is the PLONK leg that checks ZK Stack batch proofs with BN254 elliptic-curve and pairing precompiles. With the setup trapdoor, a quantum attacker can make a false proof pass the final pairing and get a false batch accepted for the chains routed here.

## Evidence

- [finalPairing](https://etherscan.io/address/0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6#code) accepts the proof when the BN254 pairing precompile (address 8) returns true.
- [The verifier](https://etherscan.io/address/0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6#code) combines proof points with the ecMul (7) and ecAdd (6) precompiles.
- [Verification](https://etherscan.io/address/0x2db2ffdecb7446aaab01fac3f4d55863db3c5bd6#code) returns true after the final pairing step.

## Reviewer notes

### Mechanism

The ExecutorFacet calls the chain's DualVerifier (0xd71ddc99…, chains 1217 and 375). That contract routes proof type 1 to this immutable PLONK leg. The verification body runs loadProof, initializeTranscript, verifyQuotientEvaluation, prepareQueries and prepareAggregatedCommitment. The aggregation uses pointMulIntoDest/pointMulAndAddIntoDest (ecMul precompile 7, lines 394/437) and pointAdd*/pointSubAssign (ecAdd precompile 6, lines 405-441). finalPairing (lines 1656-1680) calls the pairing precompile 8 at line 1673 against the fixed G2 setup elements, then the body returns true (line 1705). Knowledge of the KZG setup trapdoor, which a quantum attacker can obtain by solving the discrete log on BN254, lets an attacker build openings that satisfy this pairing for false public inputs. A false batch's L2→L1 logs then authorise withdrawals from the shared L1NativeTokenVault, up to those chains' balances. The contract itself holds no funds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and has no admin.
- Ruled out: The contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
