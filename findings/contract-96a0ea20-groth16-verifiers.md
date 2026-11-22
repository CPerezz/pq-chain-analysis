---
id: contract-96a0ea20-groth16-verifiers
format: 2
title: Hinkal Groth16 verifier checks BN254 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 Groth16 falls to a recovered setup trapdoor; the pool owner can fix it only after new post-quantum
  circuits exist.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96a0ea201f11ff3aad8cf463d438292acd6fb34a'
  project: hinkal
  code: decompiled
  code_url: code/0xb83ef05727d90a3daf4f6c71285f0a8dc95c331bd9138d6bb4d3f00022af10e7.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits and have each pool owner register their verifiers in place of the BN254 Groth16
  ones.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x96a0ea201f11ff3aad8cf463d438292acd6fb34a'
  has: 60076107d05a03fa
  says: The code calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x96a0ea201f11ff3aad8cf463d438292acd6fb34a'
  has: 60066107d05a03fa
  says: The code calls the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x96a0ea201f11ff3aad8cf463d438292acd6fb34a'
  has: 60086107d05a03fa
  says: The code calls the BN254 pairing precompile, used by the Groth16 check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x96a0ea201f11ff3aad8cf463d438292acd6fb34a'
  is: contract
  bytes: 4494
  says: The address holds contract code.
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is a Groth16 proof verifier formerly used by a Hinkal shielded pool. It accepts a proof if a pairing check on the BN254 curve passes. A quantum attacker who recovers the circuit's setup trapdoor can make a false proof pass this check.

## Evidence

- [Runtime code](https://etherscan.io/address/0x96a0ea201f11ff3aad8cf463d438292acd6fb34a#code) calls the BN254 pairing precompile to accept or reject a proof.
- [Runtime code](https://etherscan.io/address/0x96a0ea201f11ff3aad8cf463d438292acd6fb34a#code) calls the BN254 addition and multiplication precompiles to combine the public inputs.

## Reviewer notes

### Mechanism

Unverified bytecode (4494 bytes). The runtime code calls the BN254 multiplication precompile 0x07 (offset 173) and the addition precompile 0x06 (offset 221) to build the public-input linear combination. It then calls the pairing precompile 0x08 (offset 3791), which is the snarkjs-style Groth16 verifyProof pattern. The decompiled entry point requires calldata of 0x544 bytes, consistent with 34 public inputs. Per kev, Hinkal.transact on pool 0x25e5e82f… reached this verifier through a wrapper registered in verifierMap until 2026-06-10, and funds moved only if verifyProof returned true. Kev reports that no current registry entry reaches it. The live replacement verifiers are also BN254 Groth16. Forging a proof requires the circuit's setup trapdoor, which a quantum computer can recover from the discrete logs in the setup.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds itself.
- Ruled out: Kev reports this verifier is retired: no pool registry entry points to it since 2026-06-10.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
