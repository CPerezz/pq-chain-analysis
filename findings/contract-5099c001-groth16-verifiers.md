---
id: contract-5099c001-groth16-verifiers
format: 2
title: Hinkal verifier checks BN254 Groth16 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Its BN254 Groth16 check falls to a quantum attacker; pool owners can swap in post-quantum verifiers
  once circuits exist.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a'
  project: hinkal
  code: decompiled
  code_url: code/0x0be397a5699644f59ba4c945ca49c22a71717da25be580b3cd8111f9d25f9372.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits, deploy their verifiers, and have each pool owner register them in place of
  BN254 ones
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a'
  has: 60076107d05a03fa
  says: code calls the BN254 multiplication precompile
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a'
  has: 60066107d05a03fa
  says: code calls the BN254 addition precompile
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a'
  has: 60086107d05a03fa
  says: code calls the BN254 pairing precompile
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel
  selector: '0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a'
  fn: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[20])
  says: the Groth16 verifyProof entry point with 20 public inputs is in the code
  for:
  - evidence-1
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
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies Groth16 proofs with 20 public inputs, using the BN254 addition, multiplication and pairing precompiles. A quantum attacker who recovers the circuit's setup trapdoor could produce a false proof that this check accepts.

## Evidence

- The [code](https://etherscan.io/address/0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a#code) exposes a snarkjs-style verifyProof taking 20 public inputs.
- The [code](https://etherscan.io/address/0x5099c001ca25bf16c2c3f9250b2b44d5f24c5f9a#code) settles the proof with the BN254 pairing precompile.

## Reviewer notes

### Mechanism

Bytecode only, with no verified source. The runtime code exposes verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[20]) (selector 0xe56ac42f). Heimdall shows calldata length checks up to 0x384, which matches 20 public inputs. The code computes the linear combination of inputs with the BN254 ecMul (offset 173) and ecAdd (offset 221) precompiles. It then checks the Groth16 pairing equation with the ecPairing precompile (offset 2657). Per kev, a Hinkal wrapper forwarded Hinkal.transact proofs here through VerifierFacade.verifierMap until the circuits were re-registered. Whoever knows the setup trapdoor can satisfy the pairing check for false statements.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy; holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
