---
id: sp1verifier-65b299f6-sp1-verifier
format: 2
title: SP1Beefy's Groth16 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a setup trapdoor; MEDIUM because the consumer's admin can repoint to a
  hash-based verifier
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0x65b299f6d365f34a04b67f602b89f6fab094a012#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint SP1Beefy to a hash-based SP1 verifier through its admin
evidence_level: source
checks:
- id: c1
  source: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  file: lib/sp1-contracts/contracts/src/ISP1Verifier.sol
  line: 14
  has: function verifyProof(
  says: The SP1 verifier interface consumers call to verify proofs.
  for:
  - action
- id: c2
  source: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  file: lib/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  line: 41
  has: function verifyProof(
  says: verifyProof is the entry point of this Groth16 verifier.
  for:
  - justification
  - what
- id: inputs
  source: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  file: lib/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: inputs[0] = uint256(programVKey);
  line: 54
  says: The program key is a public input to the proof.
  for:
  - evidence-1
  - what
- id: pairing
  source: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  file: lib/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: this.Verify(proof, inputs);
  line: 57
  says: Acceptance rests on the Groth16 Verify check.
  for:
  - evidence-1
  - justification
  - what
- id: version
  source: '0x65b299f6d365f34a04b67f602b89f6fab094a012'
  file: lib/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: return "v5.0.0";
  line: 21
  says: The verifier is version v5.0.0.
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This immutable SP1 verifier accepts a program output when a Groth16 proof on BN254 verifies for the program key and hashed public values. A quantum attacker who recovers the setup trapdoor can make a proof for any output that this verifier accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x65b299f6d365f34a04b67f602b89f6fab094a012#code) passes the program key and public-values digest to the Groth16 Verify call.
- [VERSION](https://etherscan.io/address/0x65b299f6d365f34a04b67f602b89f6fab094a012#code) returns v5.0.0, the Groth16 wrap of the SP1 STARK.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (line 41) checks that the first 4 bytes of proofBytes equal the VERIFIER_HASH prefix (lines 46-50), hashes publicValues with sha256 masked to 253 bits (line 34), sets inputs to programVKey and the digest (lines 53-55), decodes eight uint256 proof words and calls this.Verify (line 57), the inherited gnark Groth16Verifier that ends in the BN254 pairing check. Knowledge of the trusted-setup trapdoor lets an attacker produce a valid proof for arbitrary inputs. The contract has no admin and no upgrade path; per kev's finding it is pinned by SP1Beefy, which must repoint.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: No upgrade or admin path in this contract.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
