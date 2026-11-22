---
id: plonkverifier-e067e013-plonk-verifier
format: 2
title: Rarimo rollup PLONK verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged proofs can finalize false rollup state and release bridged ETH; Rarimo's admin can register
  a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe067e0132137a517c86625e09dba914625e2f557'
  name: PlonkVerifier
  project: rarimo
  code: verified
  code_url: https://etherscan.io/address/0xe067e0132137a517c86625e09dba914625e2f557#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a hash-based verifier for the same circuit with setVerifierAddress and unset the unused PLONK proof
  types.
evidence_level: source
checks:
- id: c1
  source: '0xe067e0132137a517c86625e09dba914625e2f557'
  file: src/verifiers/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Final proof check is a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: g2
  source: '0xe067e0132137a517c86625e09dba914625e2f557'
  file: src/verifiers/PlonkVerifier.sol
  has: mstore(add(mPtr, 0x100), G2_SRS_1_X_0)
  line: 887
  says: The pairing input uses the verifying key's G2 setup point.
  for:
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
  who: Review16 (chain reads, Sourcify source, Rarimo docs)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies gnark PLONK proofs for the Rarimo rollup and accepts a proof when a BN254 pairing check against fixed setup points succeeds. A quantum attacker who recovers the setup trapdoor can make a proof for any public input pass, letting the rollup finalize a false L2 state.

## Evidence

- [check_pairing_kzg](https://etherscan.io/address/0xe067e0132137a517c86625e09dba914625e2f557#code) decides the proof with a staticcall to the BN254 pairing precompile.
- [batch_verify_multi_points](https://etherscan.io/address/0xe067e0132137a517c86625e09dba914625e2f557#code) pairs the folded proof with the verifying key's G2 setup points.

## Reviewer notes

### Mechanism

LineaRollup.finalizeBlocks on the Rarimo rollup proxy calls verifiers[3] (this contract) via Verify(proof, publicInput). In PlonkVerifier.sol, batch_verify_multi_points (lines ~813-891) folds the KZG openings using EC_MUL/EC_ADD precompile calls (lines 852, 1286, 1304), loads G2_SRS_0 and G2_SRS_1 (lines 881-890) and calls check_pairing_kzg, whose staticcall to precompile 8 at line 901 sets STATE_SUCCESS. Knowing the SRS trapdoor (recoverable by a CRQC from the BN254 setup points) lets one produce openings that satisfy this pairing for arbitrary public input, so false L2 message roots get stored and claimMessageWithProof releases the rollup's ETH.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable and holds no funds itself; exposure is the rollup's escrow.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
