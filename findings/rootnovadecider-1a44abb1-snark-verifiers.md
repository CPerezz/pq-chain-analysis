---
id: rootnovadecider-1a44abb1-snark-verifiers
format: 2
title: INTMAX RootNovaDecider accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on BN254 pairings a quantum attacker can break; INTMAX's owner Safe can repoint the zERC20
  Verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1a44abb18c35e0104dc60b794b35c2c08e6ff773'
  name: RootNovaDecider
  project: intmax
  code: verified
  code_url: https://etherscan.io/address/0x1a44abb18c35e0104dc60b794b35c2c08e6ff773#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 23
impact: funds-loss
action: Deploy a hash-based root decider and have the owner Safe repoint the zERC20 Verifier with setVerifiers.
evidence_level: source
checks:
- id: c3
  source: '0x1a44abb18c35e0104dc60b794b35c2c08e6ff773'
  file: src/verifiers/RootNovaDecider.sol
  line: 101
  has: function pairing(uint256[2] memory a_1, uint256[2][2] memory a_2, uint256[2] memory b_1, uint256[2][2] memory
    b_2)
  says: pairing helper over BN254 G1/G2 points
  for:
  - what
- id: c4
  source: '0x1a44abb18c35e0104dc60b794b35c2c08e6ff773'
  file: src/verifiers/RootNovaDecider.sol
  line: 125
  has: success := staticcall(sub(gas(), 2000), 8, input, 0x180, out, 0x20)
  says: pairing calls the BN254 pairing precompile 8
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x1a44abb18c35e0104dc60b794b35c2c08e6ff773'
  file: src/verifiers/RootNovaDecider.sol
  line: 193
  has: return pairing(pi, VK, rhs_pairing, G_2);
  says: KZG check returns the result of a BN254 pairing with fixed VK
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x1a44abb18c35e0104dc60b794b35c2c08e6ff773'
  file: src/verifiers/RootNovaDecider.sol
  line: 397
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[42] calldata
    _pubSignals) public view returns (bool) {
  says: Groth16 verifyProof with 42 public signals
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

RootNovaDecider verifies Nova decider proofs for zERC20 transfer roots with a Groth16 check and a KZG check on BN254. Both checks end in a BN254 pairing, so a quantum attacker who recovers the setup trapdoor can make a false root verify.

## Evidence

- [pairing](https://etherscan.io/address/0x1a44abb18c35e0104dc60b794b35c2c08e6ff773#code) calls the BN254 pairing precompile at address 8.
- [check](https://etherscan.io/address/0x1a44abb18c35e0104dc60b794b35c2c08e6ff773#code) accepts a KZG opening when the pairing against the fixed VK holds.
- [verifyProof](https://etherscan.io/address/0x1a44abb18c35e0104dc60b794b35c2c08e6ff773#code) is a Groth16 verifier over 42 public signals.

## Reviewer notes

### Mechanism

zERC20 Verifier.proveTransferRoot (onlyAllowedProver) calls verifyOpaqueNovaProof on this decider, which runs the snarkJS Groth16 verifyProof (line 397; g1_mulAccC uses precompiles 7 and 6 at lines 414/424) and the KZG10Verifier.check (line 171), whose pairing at line 101 calls precompile 8 (line 125). With the BN254 setup trapdoor, an allowed prover can make a false transfer root verify. The Verifier then stores it, and teleports against it can mint zERC20 that is redeemable at the LiquidityManagers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The decider holds no funds and has no admin; the exposure is through the zERC20 Verifier consumer.
- Ruled out: Only an allowed prover can submit a root.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
