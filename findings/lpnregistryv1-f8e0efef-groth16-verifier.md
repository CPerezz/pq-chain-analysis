---
id: lpnregistryv1-f8e0efef-groth16-verifier
format: 2
title: Lagrange LPN registry trusts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Query results rest on a BN254 Groth16 proof; Lagrange must upgrade the proxy to a post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf8e0efefaffa31f9c85f175147d64753e4ec8157'
  name: LPNRegistryV1
  project: lagrange
  code: verified
  code_url: https://etherscan.io/address/0xbead7fe75b567ac0fc12526225451eb3f964d834#code
  proxy_of: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  copies: 1
value:
  usd: 289
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Upgrade the implementation to a hash-based (STARK/FRI) query proof verifier, or retire the registry.
evidence_level: source
checks:
- id: c1
  source: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  file: src/v1/Groth16VerifierExtension.sol
  line: 143
  has: this.verifyProof(proofs, inputs);
  says: verifyGroth16Proof calls verifyProof on the submitted proof.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  file: src/v1/Verifier.sol
  line: 567
  has: function verifyProof(uint256[8] calldata proof, uint256[3] calldata input)
  says: verifyProof is the Groth16 verifier function.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: s-digest
  source: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  file: src/v1/Groth16VerifierExtension.sol
  has: inputs[0] == uint256(CIRCUIT_DIGEST)
  line: 138
  says: The first Groth16 input must equal the fixed circuit digest.
  for:
  - evidence-1
  - what
- id: s-output
  source: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  file: src/v1/Groth16VerifierExtension.sol
  has: return parseOutput(data, error);
  line: 116
  says: processQuery returns the output parsed from proven data.
  for:
  - evidence-3
  - what
- id: s-pair
  source: '0xbead7fe75b567ac0fc12526225451eb3f964d834'
  file: src/v1/Verifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 606
  says: verifyProof checks the pairing equation via the precompile.
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The registry accepts query results only after a Groth16 proof on BN254 verifies against a fixed circuit digest. A quantum attacker who recovers the setup trapdoor can forge proofs for any query output, which the registry then hands to the requesting client.

## Evidence

- [verifyGroth16Proof](https://etherscan.io/address/0xbead7fe75b567ac0fc12526225451eb3f964d834#code) requires the circuit digest, then calls verifyProof on the proof.
- [verifyProof](https://etherscan.io/address/0xbead7fe75b567ac0fc12526225451eb3f964d834#code) checks the Groth16 pairing equation with the pairing precompile.
- [processQuery](https://etherscan.io/address/0xbead7fe75b567ac0fc12526225451eb3f964d834#code) returns the output parsed from the proven public inputs.

## Reviewer notes

### Mechanism

processQuery (Groth16VerifierExtension.sol line 100) calls verifyGroth16Proof (line 107), which reads 8 proof words and 3 inputs from data, requires inputs[0] == CIRCUIT_DIGEST (lines 137-140) and calls this.verifyProof (line 143). verifyProof (Verifier.sol line 567) computes the public input MSM and checks the BN254 pairing via the precompile (line 606). verifyPublicInputs then ties the sha256 of the public inputs to inputs[2], verifyQuery checks block hash, computational hash and placeholders, and parseOutput returns the result rows (line 116). A forged proof made with the setup trapdoor passes for any rows. The verifier is compiled into the implementation, so replacing it needs a proxy upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No client contract holding value was found.
- Ruled out: The fees in the registry are withdrawable by the owner only.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
