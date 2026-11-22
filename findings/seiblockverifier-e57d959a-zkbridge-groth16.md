---
id: seiblockverifier-e57d959a-zkbridge-groth16
format: 2
title: Polyhedra Sei verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quantum attack recovers the Groth16 trapdoor; Polyhedra's Safe must repoint to a post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf'
  name: SeiBlockVerifier
  project: polyhedra
  code: verified
  code_url: https://etherscan.io/address/0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build hash-based Sei header proofs and have the owner Safe point SeiBlockUpdater at the new verifier.
evidence_level: source
checks:
- id: c1
  source: '0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf'
  file: contracts/block/sei/SeiBlockVerifier.sol
  line: 479
  has: function verifyProof(
  says: verifyProof is the Groth16 proof check entry point
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c-pairing
  source: '0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf'
  file: contracts/block/sei/SeiBlockVerifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 518
  says: the line or bytes the card cites
  for:
  - evidence-1
  - justification
  - what
- id: c-alpha
  source: '0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf'
  file: contracts/block/sei/SeiBlockVerifier.sol
  has: mstore(add(f, 0x180), ALPHA_X)
  line: 504
  says: the line or bytes the card cites
  for:
  - evidence-2
  - what
- id: c-revert
  source: '0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf'
  file: contracts/block/sei/SeiBlockVerifier.sol
  has: revert ProofInvalid();
  line: 466
  says: the line or bytes the card cites
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
  who: Review18 (updater verifier slots, ZKBridge endpoint and ZkBridgeOracleV2 sources, owner reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs for Sei block headers with a BN254 pairing against a hard-coded verifying key. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false Sei header.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf#code) accepts a proof when the BN254 pairing precompile check passes.
- [The verifying key](https://etherscan.io/address/0xe57d959aaeba4346b4f73b21fde6d2b9816ef0bf#code) is built into the code as constants such as ALPHA_X and DELTA_NEG_X_1.

## Reviewer notes

### Mechanism

verifyProof(proof, input) (line 479) computes the public-input commitment through publicInputMSM (line 483). It copies the proof points A, B and C into memory (line 494). It then writes the hard-coded DELTA, ALPHA, BETA and GAMMA constants (lines 500-516) and calls the pairing precompile through staticcall (line 518). If the pairing equation holds, the call returns without reverting. Per kev's finding, SeiBlockUpdater calls this verifier when it imports Sei headers. Those headers are then used by ZKBridge.validateTransactionProof (zkReceive) and by ZkBridgeOracleV2.verifyByTx through checkBlock/checkBlockConfirmation. Someone who knows the Groth16 toxic waste, which a quantum computer could derive from the verifying key, can produce a passing proof for any public input.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: The verifier is not upgradeable; it is changed by repointing the updater.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
