---
id: fflonkverifier-985e8913-fflonk-verifier
format: 2
title: Vizing fflonk verifier trusts a BN254 setup a quantum attacker could break
status: confirmed
severity: MEDIUM
justification: Pairing-based proofs fall to a quantum attacker; Vizing's timelock can upgrade to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x985e89135fb4968bca0db46422dc1ed31b985d52'
  name: FflonkVerifier
  project: vizing
  code: verified
  code_url: https://etherscan.io/address/0x985e89135fb4968bca0db46422dc1ed31b985d52#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the validium to an implementation that uses a post-quantum verifier, through Vizing's timelock.
evidence_level: source
checks:
- id: c1
  source: '0x985e89135fb4968bca0db46422dc1ed31b985d52'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 162
  has: function verifyProof(bytes32[24] calldata proof, uint256[1] calldata pubSignals) public view returns (bool)
    {
  says: verifyProof is the proof-checking entry point.
  for:
  - evidence-1
  - what
- id: c3
  source: '0x985e89135fb4968bca0db46422dc1ed31b985d52'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1090
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: ecMul precompile used for G1 commitments.
  for:
  - evidence-3
- id: c4
  source: '0x985e89135fb4968bca0db46422dc1ed31b985d52'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1100
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: ecAdd precompile used for G1 commitments.
  for:
  - evidence-3
- id: c7
  source: '0x985e89135fb4968bca0db46422dc1ed31b985d52'
  file: contracts/verifiers/FflonkVerifier.sol
  line: 1199
  has: let success := staticcall(sub(gas(), 2000), 8, mIn, 384, mIn, 0x20)
  says: Final acceptance is a BN254 pairing precompile call.
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
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies Vizing's validity proofs with an fflonk check on BN254 that ends in a pairing. A quantum attacker who recovers the setup trapdoor can forge a proof that this check accepts, proving a false Vizing state.

## Evidence

- [verifyProof](https://etherscan.io/address/0x985e89135fb4968bca0db46422dc1ed31b985d52#code) takes a 24-word proof and one public signal and returns a bool.
- [checkPairing](https://etherscan.io/address/0x985e89135fb4968bca0db46422dc1ed31b985d52#code) accepts the proof when the BN254 pairing precompile returns true.
- [g1_mulAcc](https://etherscan.io/address/0x985e89135fb4968bca0db46422dc1ed31b985d52#code) builds the commitments with BN254 point multiplication and addition precompiles.

## Reviewer notes

### Mechanism

verifyProof (l.162) runs checkInput, computeChallenges, computeInversions, computeLagrange, computePi, computeR0-R2, then computeFEJ (l.1235), which uses g1_mulAcc/g1_mulAccC/g1_acc with ecMul (precompile 7, l.1090, l.1116) and ecAdd (precompile 6, l.1074, l.1100, l.1126). checkPairing (l.1164) checks e(F-E-J+yW2,[1]_2)==e(W2,[x]_2) through precompile 8 (l.1199). Soundness rests on the KZG trapdoor x staying unknown. Kev's finding says the proxy's CDKValidium calls this verifier from _verifyAndRewardBatches, so a forged proof sets the state and exit root the bridge pays from. The verifier address is an immutable in that implementation, so the fix is a proxy upgrade through the timelock.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
