---
id: blockverifier-6150343e-groth16-verifier
format: 2
title: Loopring BlockVerifier checks Groth16 proofs that a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'Low: Loopring''s exchange no longer calls this verifier, so a forged proof releases nothing; no
  action needed.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  name: BlockVerifier
  project: loopring
  code: verified
  code_url: https://etherscan.io/address/0x6150343e0f43a17519c0327c41edd9ebe88d01ef#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdd2a08a1c1a28c1a571e098914ca10f2877d9c97'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: c1
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 581
  has: check_1 = pairing(proof_B, proof_A)
  says: Pairing check of proof_B and proof_A in the documented Groth16 equation
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 582
  has: check_2 = pairing(vk_beta, neg(vk_alpha))
  says: Pairing of vk_beta with negated vk_alpha
  for:
  - evidence-1
  - what
- id: c3
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 583
  has: check_3 = pairing(vk_gamma, neg(vk_x))
  says: Pairing of vk_gamma with negated vk_x
  for:
  - evidence-1
  - what
- id: c4
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 584
  has: check_4 = pairing(vk_delta, neg(proof_C))
  says: Pairing of vk_delta with negated proof_C
  for:
  - evidence-1
  - what
- id: c5
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 338
  has: success := staticcall(sub(gas(), 2000), 7, mul_input, 0x60, mul_input, 0x40)
  says: ECMUL precompile 7 call in accumulate
  for:
  - evidence-2
- id: c7
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 368
  has: success := staticcall(sub(gas(), 2000), 6, add_input, 0x80, add_input, 0x40)
  says: ECADD precompile 6 call
  for:
  - evidence-2
- id: c8
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 400
  has: success := staticcall(sub(gas(), 2000), 7, mul_input, 0x60, add(add_input, 0x40), 0x40)
  says: ECMUL precompile call in prepareBatches
  for:
  - evidence-2
- id: c9
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 37
  has: function transferOwnership(
  says: Ownable transferOwnership is onlyOwner
  for:
  - justification
- id: c10
  source: '0x6150343e0f43a17519c0327c41edd9ebe88d01ef'
  file: BlockVerifier.sol
  line: 85
  has: function transferOwnership(
  says: Claimable transferOwnership is onlyOwner
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

BlockVerifier accepts a Loopring block proof when Groth16 pairing checks on BN254 pass. A quantum attacker who recovers the setup trapdoor could make a false proof pass these checks.

## Evidence

- [Verify](https://etherscan.io/address/0x6150343e0f43a17519c0327c41edd9ebe88d01ef#code) is specified as the product of four BN254 pairings equalling one.
- [BatchVerify](https://etherscan.io/address/0x6150343e0f43a17519c0327c41edd9ebe88d01ef#code) combines proofs with BN254 elliptic-curve multiplication and addition precompiles.
- [transferOwnership](https://etherscan.io/address/0x6150343e0f43a17519c0327c41edd9ebe88d01ef#code) is owner-only; the owner manages this verifier's circuits.

## Reviewer notes

### Mechanism

verifyProofs (BlockVerifier.sol lines 1220-1252) loads the owner-registered Groth16 verification key for (blockType, blockSize, blockVersion) and calls Verify (ethsnarks, pairing precompile 8 near line 656) or BatchVerify (matter-labs). BatchVerify uses accumulate (ECMUL at lines 338 and 360, ECADD at line 368) and prepareBatches (line 400), with the pairing near line 516. The pairing equation is documented at lines 581-587. Soundness rests on BN254 discrete log and the trusted-setup trapdoor. The consumer was ExchangeV3 behind proxy 0x0baba1ad, which now points at the owner-only ProxyAdminExecutor and does not call verifyProofs.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Verifier holds no funds
- Ruled out: Exchange proxy no longer submits blocks through this verifier
- Ruled out: Funds left in the deposit contract depend on the Safe owners' keys, not this verifier

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
