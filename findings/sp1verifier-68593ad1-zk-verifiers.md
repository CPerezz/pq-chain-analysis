---
id: sp1verifier-68593ad1-zk-verifiers
format: 2
title: Taiko's SP1 Plonk verifier accepts BN254 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: BN254 Plonk rests on a trusted setup a quantum computer breaks; the Taiko DAO can upgrade to post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  name: SP1Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x68593ad19705e9ce919b2e368f5cb7baf04f7371#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace BN254 Plonk verifiers on Taiko's proof paths with post-quantum verifiers through a DAO upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  file: node_modules/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  line: 39
  has: function verifyProof(
  says: verifyProof entry point of the SP1 Plonk verifier.
  for:
  - justification
  - what
- id: c4
  source: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  file: node_modules/sp1-contracts/contracts/src/v4.0.0-rc.3/PlonkVerifier.sol
  line: 886
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: KZG pairing check uses the BN254 pairing precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ver
  source: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  file: node_modules/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  has: return "v4.0.0-rc.3";
  line: 21
  says: Contract reports version v4.0.0-rc.3.
  for:
  - what
- id: verify-call
  source: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  file: node_modules/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  has: bool success = this.Verify(proofBytes[4:], inputs);
  line: 54
  says: verifyProof delegates validity to the Plonk Verify routine.
  for:
  - evidence-1
  - what
- id: revert-invalid
  source: '0x68593ad19705e9ce919b2e368f5cb7baf04f7371'
  file: node_modules/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierPlonk.sol
  has: revert InvalidProof();
  line: 56
  says: A failed Plonk check reverts.
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier, SP1Verifier and Risc0Verifier wrappers;
    on-chain reads at block 26,431,535)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: Review15 (review of the former finding unidentified-fb3ca570-snark-verifier, merged here)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This SP1 v4.0.0-rc.3 verifier accepts a zkVM proof when its BN254 Plonk check passes, using a KZG pairing. A quantum attacker who recovers the setup trapdoor can make false proofs that this contract accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x68593ad19705e9ce919b2e368f5cb7baf04f7371#code) reverts unless the Plonk Verify call returns true.
- [check_pairing_kzg](https://etherscan.io/address/0x68593ad19705e9ce919b2e368f5cb7baf04f7371#code) decides validity with the BN254 pairing precompile.

## Reviewer notes

### Mechanism

SP1VerifierPlonk.verifyProof (line 39) checks that the proof's 4-byte selector matches VERIFIER_HASH (lines 44-48). It hashes the public values into a BN254 field element (line 32) and calls this.Verify (line 54), which is PlonkVerifier. Verify folds the commitments with ecmul (precompile 7, lines 834, 1330 and 1346) and decides the result with the ecpairing precompile 8 in check_pairing_kzg (line 886). If the pairing fails, verifyProof reverts with InvalidProof (line 56). Soundness rests on the KZG trusted setup. Anyone holding the trapdoor, which a quantum computer can recover, can produce proofs for arbitrary public values that pass. Kev's finding reports that Taiko's live Shasta wrappers route to a different SP1 version, not to this one.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin read.
- Ruled out: Holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
