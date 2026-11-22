---
id: contract-5b3fb770-groth16-verifiers
format: 2
title: Hinkal Groth16 verifier trusts BN254 proofs that a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 Groth16 falls to a recovered trapdoor; the fix is new circuits and verifiers Hinkal's pool
  owners register.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5b3fb770f00fadb4ae49df6882152bd1d27895ee'
  project: hinkal
  code: decompiled
  code_url: code/0x82c90a5ce6309610b90b48976cdd444c09863831389defd37e47f2454caf6d37.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x5b3fb770f00fadb4ae49df6882152bd1d27895ee'
  has: 60076107d05a03fa
  says: The code calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x5b3fb770f00fadb4ae49df6882152bd1d27895ee'
  has: 60066107d05a03fa
  says: The code calls the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x5b3fb770f00fadb4ae49df6882152bd1d27895ee'
  has: 60086107d05a03fa
  says: The code calls the BN254 pairing precompile, the Groth16 check.
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

This contract is a Groth16 proof verifier for Hinkal shielded pools that accepts a proof by checking a pairing equation on the BN254 curve. A quantum attacker who recovers the circuit's setup trapdoor can make false proofs that pass this check.

## Evidence

- [Runtime code](https://etherscan.io/address/0x5b3fb770f00fadb4ae49df6882152bd1d27895ee#code) calls the BN254 pairing precompile to check the proof.
- [Runtime code](https://etherscan.io/address/0x5b3fb770f00fadb4ae49df6882152bd1d27895ee#code) calls the BN254 addition and multiplication precompiles to combine the public inputs.

## Reviewer notes

### Mechanism

Bytecode-only verifier (snarkjs-style Groth16, 26 public inputs per kev). Its entry point takes calldata of 0x444 bytes (a, b, c and 26 inputs), folds the inputs into a point with the BN254 ecMul (0x07, offset 173) and ecAdd (0x06, offset 221) precompiles, then calls the BN254 pairing precompile (0x08, offset 3144) and returns whether the pairing equation holds. Hinkal pools reach it through a wrapper registered in VerifierFacade.verifierMap during Hinkal.transact. Kev reports this verifier retired since Hinkal re-registered every circuit; the replacement verifiers are still BN254 Groth16. Remediation is per pool: owners call registerVerifiers with post-quantum verifiers once Hinkal builds new circuits.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: The verifier is not a proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
