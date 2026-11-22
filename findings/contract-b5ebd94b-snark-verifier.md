---
id: contract-b5ebd94b-snark-verifier
format: 2
title: Pool withdraw verifier trusts Groth16 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Groth16 on BN254 falls to a recovered setup trapdoor; the pool's 2-of-3 Safe can upgrade to new verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  code: decompiled
  code_url: code/0xfb2195b940de41a3c8047730049df17089c39855e4c711614407668771a4daef.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the pool implementation to withdraw and transfer verifiers based on hash-based proofs.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  has: 60075afa
  says: The code calls the BN254 multiplication precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: b2
  bytecode: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  has: 60065afa
  says: The code calls the BN254 addition precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: b3
  bytecode: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  has: 60075afa
  says: The code calls the BN254 multiplication precompile again.
  for:
  - evidence-1
  - what
- id: b4
  bytecode: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  has: 60065afa
  says: The code calls the BN254 addition precompile again.
  for:
  - evidence-2
  - what
- id: code
  code: '0xb5ebd94b3c69c3449a64e67b055298e588f2434a'
  is: contract
  bytes: 7217
  says: The address holds deployed contract code.
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
  who: Review10 (bytecode and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks withdraw proofs for a shielded pool using BN254 elliptic-curve operations. A quantum attacker who recovers the setup trapdoor forges proofs that pass, letting withdrawals of notes that do not exist through.

## Evidence

- [Runtime code](https://etherscan.io/address/0xb5ebd94b3c69c3449a64e67b055298e588f2434a#code) calls the BN254 multiplication precompile.
- [Runtime code](https://etherscan.io/address/0xb5ebd94b3c69c3449a64e67b055298e588f2434a#code) calls the BN254 addition precompile.

## Reviewer notes

### Mechanism

Unverified gnark-style Groth16 verifier (selector 0x44f63692 compressProof per the finding). The verification path computes the public-input linear combination with repeated ecmul (0x07) and ecadd (0x06) staticcalls (bytes at offsets 433, 445, 535, 549), then runs a pairing check. Soundness rests on the trusted-setup trapdoor staying unknown. A quantum computer that recovers discrete logs on BN254 reveals the trapdoor and can produce forged proofs. Per kev, pool proxy 0x428c850b holds this verifier as an immutable WITHDRAW_VERIFIER. Fixing it takes an upgrade by the ProxyAdmin's 2-of-3 Safe.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This verifier holds no funds itself.
- Ruled out: The pairing call is not among the listed byte checks.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
