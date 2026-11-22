---
id: sp1verifier-ff5adab6-zk-verifiers
format: 2
title: Taiko SP1 v5 Plonk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 Plonk trusted setup falls to a quantum attacker; MEDIUM as the Taiko DAO can upgrade to post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xff5adab685362dc4c33536a65af5873738d1216b'
  name: SP1Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0xff5adab685362dc4c33536a65af5873738d1216b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace BN254 Plonk verification with a post-quantum proof verifier through a DAO upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xff5adab685362dc4c33536a65af5873738d1216b'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierPlonk.sol
  line: 41
  has: function verifyProof(
  says: verifyProof entry point of the SP1 Plonk verifier.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xff5adab685362dc4c33536a65af5873738d1216b'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/PlonkVerifier.sol
  line: 852
  has: let check_staticcall := staticcall(gas(), 7, folded_evals_commit, 0x60, folded_evals_commit, 0x40)
  says: Plonk verification uses the BN254 ecmul precompile.
  for:
  - what
- id: c4
  source: '0xff5adab685362dc4c33536a65af5873738d1216b'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: KZG check calls the BN254 pairing precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: v5
  source: '0xff5adab685362dc4c33536a65af5873738d1216b'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierPlonk.sol
  has: return "v5.0.0";
  line: 21
  says: The verifier version is v5.0.0.
  for:
  - what
- id: ver
  source: '0xff5adab685362dc4c33536a65af5873738d1216b'
  file: node_modules/sp1-contracts/contracts/src/v5.0.0/SP1VerifierPlonk.sol
  has: bool success = this.Verify(proofBytes[4:], inputs);
  line: 56
  says: verifyProof delegates acceptance to the Plonk Verify routine.
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

This SP1 v5.0.0 verifier accepts a Plonk proof for a program key and public values when a BN254 pairing check passes. A quantum attacker who recovers the setup trapdoor could make false proofs that pass this check.

## Evidence

- [verifyProof](https://etherscan.io/address/0xff5adab685362dc4c33536a65af5873738d1216b#code) hashes the public values and accepts the proof when Verify succeeds.
- [check_pairing_kzg](https://etherscan.io/address/0xff5adab685362dc4c33536a65af5873738d1216b#code) calls the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

SP1VerifierPlonk.verifyProof (lines 41-60) checks that the proof's first 4 bytes match VERIFIER_HASH (0xd4e8ecd2...), hashes publicValues to a BN254 field element, and calls this.Verify(proofBytes[4:], [programVKey, digest]). PlonkVerifier uses ecmul (precompile 7, lines 852, 1286, 1304) and the pairing precompile 8 in check_pairing_kzg (line 901). Kev reports this contract as the remote verifier of the Pacaya TaikoSP1Verifier proxy 0xbee1040d, which is a retired path; the live Shasta path routes SP1 proofs to v6.1.0. Forging with the KZG trapdoor makes the pairing pass for false statements.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not on the live Shasta proving path per kev; Pacaya inbox no longer writes checkpoints
- Ruled out: Contract holds no funds and has no admin

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
