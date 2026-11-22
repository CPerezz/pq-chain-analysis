---
id: sp1verifier-2bb76cb5-sp1-verifier
format: 2
title: SP1 v5 Groth16 verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a quantum setup-trapdoor attack; consumers can repoint to a hash-based
  verifier, so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0x2bb76cb5eab856ffb548320509266c5bfed46f82#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Repoint the pinned consumer to a hash-based SP1 STARK verifier through its own admin.
evidence_level: source
checks:
- id: c1
  source: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  line: 41
  has: function verifyProof(
  says: verifyProof is the entry point of this verifier.
  for:
  - action
  - justification
  - what
- id: inputs
  source: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: inputs[0] = uint256(programVKey);
  line: 54
  says: The program key is a public input to the Groth16 check.
  for:
  - evidence-1
  - what
- id: decode
  source: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: abi.decode(proofBytes[4:], (uint256[8]))
  line: 56
  says: The proof is decoded as eight field elements.
  for:
  - evidence-2
- id: verify
  source: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: this.Verify(proof, inputs);
  line: 57
  says: Acceptance depends on the Groth16 Verify call.
  for:
  - evidence-2
  - what
- id: pairing
  source: '0x2bb76cb5eab856ffb548320509266c5bfed46f82'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierGroth16.sol
  has: contract SP1Verifier is Groth16Verifier, ISP1VerifierWithHash {
  line: 10
  says: The contract inherits the Groth16 verifier.
  for:
  - evidence-3
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
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This immutable SP1 verifier accepts a program output when a Groth16 proof on BN254 verifies against the program key and the hashed public values. With the BN254 setup trapdoor, a quantum attacker could build a proof for any output, and the consumer pinned to this verifier would accept it.

## Evidence

- [verifyProof](https://etherscan.io/address/0x2bb76cb5eab856ffb548320509266c5bfed46f82#code) passes the program key and public-values digest as the Groth16 inputs.
- [verifyProof](https://etherscan.io/address/0x2bb76cb5eab856ffb548320509266c5bfed46f82#code) decodes eight BN254 field elements as the proof and calls Verify.
- [SP1Verifier](https://etherscan.io/address/0x2bb76cb5eab856ffb548320509266c5bfed46f82#code) inherits the gnark Groth16Verifier.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (line 41) checks that the first 4 bytes of proofBytes equal the VERIFIER_HASH prefix (lines 46-50). It hashes publicValues with sha256 masked to 253 bits (line 34, 52), sets inputs to [programVKey, digest] (lines 54-55), decodes uint256[8] from proofBytes[4:] (line 56), and calls this.Verify (line 57) from the inherited gnark Groth16Verifier (line 10), which ends in the BN254 pairing check. With the Groth16 setup trapdoor, which a quantum computer can recover from the BN254 discrete logarithms in the verifying key, a valid-looking proof can be made for any programVKey and public values. The contract has no admin and no upgrade path, so the fix is for consumers, such as the SP1ICS07Tendermint client that kev found pinned to this deployment, to repoint to a hash-based verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: No upgrade or admin function is in the verified source.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
