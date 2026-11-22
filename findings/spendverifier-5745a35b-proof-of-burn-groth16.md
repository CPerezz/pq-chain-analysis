---
id: spendverifier-5745a35b-proof-of-burn-groth16
format: 2
title: WORM BETH spend verifier accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: CRITICAL
justification: Forged spend proofs mint BETH; the verifying key is hard-coded, so only a new WORM deployment fixes
  it
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5745a35b9c5938b2307f0287f45df5743a9d02e6'
  name: SpendVerifier
  project: worm
  code: verified
  code_url: https://etherscan.io/address/0x5745a35b9c5938b2307f0287f45df5743a9d02e6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a new BETH with a hash-based (STARK/FRI or WHIR) spend verifier and move holders and pools to it
evidence_level: source
checks:
- id: c1
  source: '0x5745a35b9c5938b2307f0287f45df5743a9d02e6'
  file: src/SpendVerifier.sol
  line: 62
  has: function verifyProof(
  says: verifyProof entry point
  for:
  - what
- id: c2
  source: '0x5745a35b9c5938b2307f0287f45df5743a9d02e6'
  file: src/SpendVerifier.sol
  line: 153
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Groth16 check via the BN254 pairing precompile
  for:
  - evidence-1
  - justification
  - what
- id: vk
  source: '0x5745a35b9c5938b2307f0287f45df5743a9d02e6'
  file: src/SpendVerifier.sol
  has: uint256 constant deltax1 =
  line: 45
  says: The verifying key is hard-coded as constants
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setup
  source: '0x5745a35b9c5938b2307f0287f45df5743a9d02e6'
  file: src/SpendVerifier.sol
  has: https://github.com/worm-privacy/trusted-setup/releases/tag/final
  line: 22
  says: Parameters come from the WORM trusted setup
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
reviews: []
related: []
---

## What happens

This verifier checks Groth16 proofs for BETH spends against a hard-coded verifying key using the BN254 pairing precompile. A quantum attacker who recovers the trusted-setup trapdoor can make proofs that verify for any statement, letting BETH mint coins that were never burned.

## Evidence

- [verifyProof](https://etherscan.io/address/0x5745a35b9c5938b2307f0287f45df5743a9d02e6#code) returns the result of a BN254 pairing check (precompile 8).
- The [verifying key](https://etherscan.io/address/0x5745a35b9c5938b2307f0287f45df5743a9d02e6#code) is stored as compile-time constants, and the contract has no function that changes it.
- The [parameters](https://etherscan.io/address/0x5745a35b9c5938b2307f0287f45df5743a9d02e6#code) come from the WORM trusted-setup ceremony.

## Reviewer notes

### Mechanism

BETH.spendCoin calls spendVerifier.verifyProof(pA, pB, pC, [commitment]). In SpendVerifier.verifyProof (line 62), checkField checks the single public signal (line 163). checkPairing then builds vk_x = IC0 + s*IC1 using ecMul and ecAdd (lines 84 and 94). It runs the Groth16 pairing check against the constant alpha, beta, gamma and delta (lines 35-48) with staticcall to precompile 8 (line 153). The function returns that result (lines 155-169). Anyone who knows the setup trapdoor (toxic waste), which a CRQC can recover from the key through discrete logs, can forge A, B and C for any commitment. The key is a set of constants, and BETH holds the verifier as immutable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself holds no funds
- Ruled out: No upgrade path or admin on the verifier

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
