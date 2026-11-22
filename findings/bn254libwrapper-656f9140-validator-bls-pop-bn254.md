---
id: bn254libwrapper-656f9140-validator-bls-pop-bn254
format: 2
title: Aztec BLS key wrapper accepts pairing proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'Low: the forged proof only reserves a BLS key. Aztec Governance can adopt post-quantum keys in a
  new GSE.'
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x656f9140b9e2d3769d47b575512d46039dcab4d3'
  name: Bn254LibWrapper
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x656f9140b9e2d3769d47b575512d46039dcab4d3#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 422
impact: liveness
action: Adopt post-quantum validator keys in a new GSE before any rollup verifies BLS attestations on L1.
evidence_level: source
checks:
- id: pop-fn
  source: '0x656f9140b9e2d3769d47b575512d46039dcab4d3'
  file: lib/l1-contracts/src/governance/Bn254LibWrapper.sol
  has: return BN254Lib.proofOfPossession(_publicKeyInG1, _publicKeyInG2, _proofOfPossession);
  line: 14
  says: wrapper returns the BN254 proof-of-possession result
  for:
  - action
  - evidence-1
  - justification
  - what
- id: pairing
  source: '0x656f9140b9e2d3769d47b575512d46039dcab4d3'
  file: lib/l1-contracts/src/shared/libraries/BN254Lib.sol
  has: return bn254Pairing(left, g2NegatedGenerator(), right, pk2);
  line: 101
  says: proof is accepted by a BN254 pairing check
  for:
  - evidence-2
  - justification
  - what
- id: domain
  source: '0x656f9140b9e2d3769d47b575512d46039dcab4d3'
  file: lib/l1-contracts/src/shared/libraries/BN254Lib.sol
  has: bytes32("AZTEC_BLS_POP_BN254_V1")
  line: 45
  says: proof is a BLS proof of possession for staking
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
  who: Review00 (GSE and rollup v3 source read for every use of the BLS keys; creator and owner reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks a BN254 BLS proof of possession for a validator's public key with a pairing. A quantum attacker can recover a BLS secret key from its public key and produce a proof that passes for any key, for example to reserve another validator's key first.

## Evidence

- [proofOfPossession](https://etherscan.io/address/0x656f9140b9e2d3769d47b575512d46039dcab4d3#code) returns the result of the BN254 library check for the G1 and G2 keys.
- [BN254Lib](https://etherscan.io/address/0x656f9140b9e2d3769d47b575512d46039dcab4d3#code) accepts the proof when the pairing e(L, -G2) * e(R, pk2) equals one.

## Reviewer notes

### Mechanism

Rollup.deposit -> StakingLib queue -> GSE.deposit -> GSE._checkProofOfPossession rejects an already-seen G1 key (ownedPKs) and calls Bn254LibWrapper.proofOfPossession (wrapper line 14), which runs BN254Lib.proofOfPossession: hash-to-point of pk1 under domain AZTEC_BLS_POP_BN254_V1 (line 45), builds R (line 98) and checks e(L,-G2)*e(R,pk2)==1 via bn254Pairing (lines 101, 163-198). The G1 key is stored in configOf[attester]; no L1 contract verifies BLS signatures with it. Attestations are ECDSA, and the stake is still required and withdrawn by the withdrawer address. Worst case: front-running registration of someone else's key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds held by the wrapper
- Ruled out: Stake withdrawal is not gated by the BLS key
- Ruled out: L1 attestations are ECDSA, not BLS

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
