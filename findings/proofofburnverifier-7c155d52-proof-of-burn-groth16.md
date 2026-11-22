---
id: proofofburnverifier-7c155d52-proof-of-burn-groth16
format: 2
title: WORM burn verifier trusts a Groth16 setup a quantum attacker can break
status: confirmed
severity: CRITICAL
justification: A recovered setup trapdoor lets forged burn proofs verify; the verifier is immutable, so WORM must
  redeploy.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7c155d52b78799d4975417a3815cde8c5aec434f'
  name: ProofOfBurnVerifier
  project: worm
  code: verified
  code_url: https://etherscan.io/address/0x7c155d52b78799d4975417a3815cde8c5aec434f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 90
impact: funds-loss
action: Deploy a hash-based (STARK/FRI) proof-of-burn verifier and a new BETH that uses it, and move holders and
  pools to it.
evidence_level: source
checks:
- id: c1
  source: '0x7c155d52b78799d4975417a3815cde8c5aec434f'
  file: src/ProofOfBurnVerifier.sol
  line: 62
  has: function verifyProof(
  says: verifyProof is the public entry point.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7c155d52b78799d4975417a3815cde8c5aec434f'
  file: src/ProofOfBurnVerifier.sol
  line: 153
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: The proof is accepted based on a BN254 pairing precompile call.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: vk
  source: '0x7c155d52b78799d4975417a3815cde8c5aec434f'
  file: src/ProofOfBurnVerifier.sol
  has: uint256 constant deltax1 =
  line: 45
  says: The verifying key delta is a hard-coded constant.
  for:
  - evidence-2
  - what
- id: setup
  source: '0x7c155d52b78799d4975417a3815cde8c5aec434f'
  file: src/ProofOfBurnVerifier.sol
  has: worm-privacy/trusted-setup/releases/tag/final
  line: 22
  says: The key parameters come from WORM's trusted setup.
  for:
  - evidence-2
  - what
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

This contract checks Groth16 proofs of ETH burns against a hard-coded verifying key with the BN254 pairing precompile. A quantum attacker who recovers the setup trapdoor can make proofs of burns that never happened verify, so BETH mints coins for them.

## Evidence

- [verifyProof](https://etherscan.io/address/0x7c155d52b78799d4975417a3815cde8c5aec434f#code) returns the result of a BN254 pairing check with precompile 8.
- The [verifying key](https://etherscan.io/address/0x7c155d52b78799d4975417a3815cde8c5aec434f#code) is compiled in as constants from the WORM trusted setup.

## Reviewer notes

### Mechanism

ProofOfBurnVerifier.verifyProof (line 62) takes pA, pB, pC and one public signal. It checks that the signal is in the field (line 163). checkPairing builds vk_x = IC0 + signal*IC1 with precompiles 7 and 6 (lines 84, 94). It then runs a pairing of -A,B / alpha,beta / vk_x,gamma / C,delta with precompile 8 (line 153) and returns success && result. The key constants (lines 35-54) come from the worm-privacy trusted setup (line 22). Anyone who knows that setup's toxic waste, for example recovered by solving discrete logs on BN254 with a quantum computer, can build proofs for any commitment. Per kev, BETH.mintCoin requires this verifier and mints up to 10 BETH per proof with fresh nullifiers. BETH holds the verifier as an immutable and has no admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: The verifier is not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
