---
id: aaveethdynamicfeeverifier6h-2-bda7b855-snark-verifier
format: 2
title: AAVE/ETH dynamic-fee verifier accepts KZG proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: A forged proof only sets a pool swap fee, nothing can be taken; the FeeManager owner can repoint
  the verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca'
  name: AAVEETHDynamicFeeVerifier6h_2
  code: verified
  code_url: https://etherscan.io/address/0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Point both FeeManagers at a post-quantum (hash-based) fee verifier via updateVerifier.
evidence_level: source
checks:
- id: c1
  source: '0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h_2.sol
  line: 69
  has: function verifyProof(
  says: verifyProof is the entry point taking proof and instances.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h_2.sol
  line: 173
  has: ret := and(success, staticcall(gas(), 0x07, 0x00, 0x60, 0x00, 0x40))
  says: Uses BN254 ecMul precompile 0x07.
  for:
  - evidence-3
  - what
- id: c6
  source: '0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h_2.sol
  line: 206
  has: ret := and(success, staticcall(gas(), 0x08, 0x00, 0x180, 0x00, 0x20))
  says: Final check calls BN254 pairing precompile 0x08.
  for:
  - evidence-2
  - justification
  - what
- id: s-g2
  source: '0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca'
  file: src/verifiers/AAVEETHDynamicFeeVerifier6h_2.sol
  has: mstore(0x100, mload(NEG_S_G2_X_1_MPTR))
  line: 202
  says: the line or bytes the card cites
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
- study: top-callers-classification
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Halo2 proofs with KZG commitments on BN254 for an AAVE/ETH volatility fee, ending in one pairing check. A quantum attacker who recovers the setup trapdoor can make it accept a proof for any fee value.

## Evidence

- [verifyProof](https://etherscan.io/address/0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca#code) takes a proof and public instances and returns a bool.
- [ec_pairing](https://etherscan.io/address/0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca#code) calls the BN254 pairing precompile against the setup point [s]G2.
- [ec_mul_acc](https://etherscan.io/address/0xbda7b85529d70e7c5895bae5cb20cf9bc5a652ca#code) uses the BN254 scalar-multiplication precompile to fold commitments.

## Reviewer notes

### Mechanism

verifyProof (line 69) reads EC points, derives Fiat-Shamir challenges with keccak, and accumulates KZG commitments via ecAdd/ecMul precompiles (lines 167, 173, 181, 188). Field inversion uses modexp (line 139). The final ec_pairing (lines 193-207) checks e(lhs, G2) * e(rhs, -[s]G2) == 1 via precompile 0x08 (line 206). Knowing the KZG trapdoor s, which a quantum computer can extract from [s]G2 by discrete log, allows forging openings, so arbitrary instances verify. Per kev, FeeManagerV3.updateFee also requires a Lit ECDSA signature on the inputs, then stores the fee that publishFee pushes to the Balancer pools as a swap-fee percentage; no pool balance moves.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds.
- Ruled out: A forged fee update cannot withdraw pool balances.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
