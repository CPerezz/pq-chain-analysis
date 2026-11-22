---
id: contract-fd5d3ea5-snark-verifier
format: 2
title: Unidentified shielded pool's Groth16 verifier trusts a quantum-breakable setup
status: candidate
severity: MEDIUM
justification: BN254 Groth16 proofs are forgeable with a recovered setup trapdoor; the pool's admin can upgrade
  to new verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  code: decompiled
  code_url: code/0x3e5c45ef37c3d86f86365d85416ffeeca5baef2a34f00bca53ac03353aaed697.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the pool implementation to use hash-based proof verifiers in place of this Groth16 verifier.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  has: 60075afa
  says: code calls BN254 ecmul
  for:
  - evidence-1
  - justification
  - what
- id: b2
  bytecode: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  has: 60065afa
  says: code calls BN254 ecadd
  for:
  - evidence-1
  - justification
  - what
- id: b3
  bytecode: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  has: 60075afa
  says: code calls BN254 ecmul again
  for:
  - evidence-1
- id: b4
  bytecode: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  has: 60065afa
  says: code calls BN254 ecadd again
  for:
  - evidence-1
- id: sel-compress
  selector: '0xfd5d3ea58cce8da4b1606db610c8129eca278ac7'
  fn: compressProof(uint256[8])
  says: gnark Groth16 export selector is in the code
  for:
  - action
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
  who: Review10 (bytecode and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies Groth16 proofs on the BN254 curve, using the elliptic-curve addition and multiplication precompiles. A quantum attacker who recovers the setup trapdoor can forge proofs that this verifier accepts.

## Evidence

- [Verifier code](https://etherscan.io/address/0xfd5d3ea58cce8da4b1606db610c8129eca278ac7#code) calls the BN254 multiplication and addition precompiles.
- [Verifier code](https://etherscan.io/address/0xfd5d3ea58cce8da4b1606db610c8129eca278ac7#code) carries the selector of gnark's Groth16 proof compression.

## Reviewer notes

### Mechanism

Bytecode-only verifier (no verified source). The runtime code holds the selector 0x44f63692 (compressProof(uint256[8]), gnark's Solidity Groth16 export) and a 0x47e5cd34 verification entry that makes repeated staticcalls to precompile 0x07 (ecmul) and 0x06 (ecadd) to build the public-input linear combination; per kev every verification also calls ecpairing. Field checks use the BN254 modulus 0x30644e72.... Per kev, the pool proxy 0x428c850b... holds this address as the immutable TRANSFER_VERIFIER of its implementation, so a forged proof lets an attacker spend non-existent notes. The proxy's ProxyAdmin is owned by a 2-of-3 Safe that can upgrade the implementation to new verifiers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself is not upgradeable and holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
