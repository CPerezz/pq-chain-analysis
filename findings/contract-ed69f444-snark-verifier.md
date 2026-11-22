---
id: contract-ed69f444-snark-verifier
format: 2
title: RISC Zero block-history prover trusts a Groth16 setup a quantum attacker breaks
status: candidate
severity: MEDIUM
justification: Groth16 over BN254 relies on a setup trapdoor a quantum attacker can recover; one admin can upgrade
  to a STARK verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xed69f44448f597f55b3a9f1ad5bf61feee54c14c'
  code: decompiled
  code_url: code/0x1f3c498bfd5f47c6b2c25a308bb1d167d49c081ec1404434ec68915e20b816eb.sol
  proxy_of: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 213
impact: liveness
action: Upgrade the implementation to verify the RISC Zero STARK receipt or another hash-based proof instead of
  Groth16.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  has: 60076107d05a03fa
  says: the code calls the bn254 multiplication precompile
  for:
  - evidence-1
  - justification
  - what
- id: b2
  bytecode: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  has: 60066107d05a03fa
  says: the code calls the bn254 addition precompile
  for:
  - evidence-1
  - what
- id: b3
  bytecode: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  has: 60086107d05a03fa
  says: the code calls the bn254 pairing precompile
  for:
  - evidence-1
  - justification
  - what
- id: verify-sel
  selector: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  fn: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[5])
  says: the implementation exposes a Groth16 verifier with five public inputs
  for:
  - evidence-2
  - what
- id: image-sel
  selector: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  fn: setImageId(bytes32)
  says: the implementation sets a RISC Zero image id
  for:
  - evidence-2
- id: meta-sel
  selector: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  fn: latestBlockMetadata()
  says: the implementation stores and returns latest block metadata
  for:
  - what
- id: admin-sel
  selector: '0x93d20f8b2798392db91b7cf9ebc111fe2e596378'
  fn: upgradeToAndCall(address,bytes)
  says: the implementation is UUPS-upgradeable by its admin
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This proxied contract records block metadata after checking a Groth16 proof over BN254 with pairing precompiles. A quantum attacker who recovers the setup trapdoor forges proofs and records any metadata it chooses.

## Evidence

- [Implementation code](https://etherscan.io/address/0x93d20f8b2798392db91b7cf9ebc111fe2e596378#code) calls the bn254 pairing, multiplication and addition precompiles.
- [Implementation code](https://etherscan.io/address/0x93d20f8b2798392db91b7cf9ebc111fe2e596378#code) exposes a five-input Groth16 verifyProof and setImageId, the RISC Zero layout.

## Reviewer notes

### Mechanism

The ERC1967 proxy delegates to an unverified implementation. A whitelisted USER_ROLE account submits via selector 0xe21962c8 eight proof words plus previous and new (height, digest); the code computes a sha256 claim digest against the image id set by setImageId and runs a Groth16 pairing check (ecmul at offset 7822, ecadd at 7983, ecpairing at 8831) with five public inputs via verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[5]). On success latestBlockMetadata is advanced. Recovering the BN254 setup trapdoor lets anyone forge accepted proofs. The implementation is UUPS-upgradeable via upgradeToAndCall by the DEFAULT_ADMIN_ROLE holder.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No on-chain contract was seen reading the stored metadata.
- Ruled out: The proxy holds no ETH or tokens of value.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
