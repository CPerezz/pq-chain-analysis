---
id: contract-31981405-groth16-verifier
format: 2
title: zkGarden pool accepts Groth16 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Pairing-based proofs fall to a CRQC; the owner can upgrade the implementation to a hash-based proof
  system.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x319814051b9520ddd58a8269362f1e283866441a'
  project: zkgarden
  code: decompiled
  code_url: code/0x4d61d4e6402e60c806a8f2b0cfdabd2553953655a5debba580afd35c925cd00f.sol
  proxy_of: '0x32504034b3622d1459e9d5d55d93c2439ac17ea1'
  copies: 1
  upgradeable: 'yes'
  admin: '0x7288b0132bbfce7eaa7361330319e1ec7a859059'
value:
  usd: 30
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the implementation to a hash-based proof system with matching circuits, or pause and retire the
  pool.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x32504034b3622d1459e9d5d55d93c2439ac17ea1'
  has: 60077ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8305a01fa
  says: The implementation calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x32504034b3622d1459e9d5d55d93c2439ac17ea1'
  has: 60067ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8305a01fa
  says: The implementation calls the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x32504034b3622d1459e9d5d55d93c2439ac17ea1'
  has: 6008602094fa
  says: The implementation calls the BN254 pairing precompile.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0x319814051b9520ddd58a8269362f1e283866441a'
  is: contract
  bytes: 2021
  says: The proxy address holds contract code.
  for:
  - action
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This proxy runs a shielded pool implementation that checks proofs with BN254 elliptic-curve and pairing precompiles. A quantum attacker who recovers the setup trapdoor can forge proofs that pass this check and withdraw the pool's deposits.

## Evidence

- The [implementation](https://etherscan.io/address/0x32504034b3622d1459e9d5d55d93c2439ac17ea1#code) calls the BN254 pairing precompile.
- The [implementation](https://etherscan.io/address/0x32504034b3622d1459e9d5d55d93c2439ac17ea1#code) calls the BN254 addition and multiplication precompiles.

## Reviewer notes

### Mechanism

The proxy 0x31981405 delegates to the unverified implementation 0x32504034. Per the bytecode, the implementation calls the BN254 multiplication precompile (offset 20574), the addition precompile (offset 20820) and the pairing precompile (offset 21742). This is the Groth16 verification step. User entry points 0xa495f6a1 and 0x032e0530 take arrays of proof tuples. The census treats each proof as checked against owner-set verification keys (setVerificationKey, VerifyingKeySet event) before tokens move. A CRQC that recovers the trusted-setup trapdoor can produce proofs that pass for false spends. Rotating keys does not help because every pairing-based key is forgeable. Upgradeability runs through admin 0x7288b013, owned by EOA 0x0105290a. That the proof gates withdrawals is inferred from the bytecode; the implementation source is unverified.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Verification-key rotation alone does not fix this; any pairing-based key is forgeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
