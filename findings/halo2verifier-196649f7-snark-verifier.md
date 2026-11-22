---
id: halo2verifier-196649f7-snark-verifier
format: 2
title: Retired Halo2 fee verifier accepts KZG proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: Proof check rests on a BN254 pairing; it only gated a swap-fee setting and the owner Safe can repoint
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68'
  name: Halo2Verifier
  code: verified
  code_url: https://etherscan.io/address/0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep this verifier unused; point the FeeManagers at a hash-based (STARK/FRI) verifier via updateVerifier.
evidence_level: source
checks:
- id: c1
  source: '0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68'
  file: Halo2Verifier.sol
  line: 65
  has: function verifyProof(
  says: verifyProof is the entry point of the verifier.
  for:
  - action
  - what
- id: c2
  source: '0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68'
  file: Halo2Verifier.sol
  line: 163
  has: ret := and(success, staticcall(gas(), 0x06, 0x00, 0x80, 0x00, 0x40))
  says: Points are added with the BN254 ecAdd precompile.
  for:
  - what
- id: c3
  source: '0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68'
  file: Halo2Verifier.sol
  line: 169
  has: ret := and(success, staticcall(gas(), 0x07, 0x00, 0x60, 0x00, 0x40))
  says: Points are scaled with the BN254 ecMul precompile.
  for:
  - evidence-2
  - what
- id: c6
  source: '0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68'
  file: Halo2Verifier.sol
  line: 202
  has: ret := and(success, staticcall(gas(), 0x08, 0x00, 0x180, 0x00, 0x20))
  says: Acceptance depends on a BN254 pairing precompile call.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies Halo2 proofs with KZG commitments on BN254, using elliptic-curve addition, multiplication and a final pairing check. A quantum attacker who recovers the setup trapdoor could make it accept a forged proof.

## Evidence

- [verifyProof](https://etherscan.io/address/0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68#code) ends in a BN254 pairing precompile call that decides acceptance.
- [ec_mul_acc](https://etherscan.io/address/0x196649f7533e8eb7161f9c98cd8f77bcb3f7ec68#code) scales commitment points with the BN254 multiplication precompile.

## Reviewer notes

### Mechanism

verifyProof (line 65) reads proof points, checks they lie on BN254 (read_ec_point, line 79), derives challenges with keccak (squeeze_challenge), accumulates commitments via ec_add_acc/ec_mul_acc (precompiles 0x06/0x07, lines 163/169), inverts with modexp (line 135), and finishes with ec_pairing (precompile 0x08, line 202) against the G2 and -sG2 points of the KZG setup. Soundness rests on the discrete log of the setup secret, which a quantum computer can recover. Per kev's finding this earlier build was used by FeeManagerV3 updateFee (alongside a Lit ECDSA signature) to set a Balancer swap fee, and is now retired in favour of 0xbda7b855.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds held by this verifier.
- Ruled out: Not upgradeable.
- Ruled out: Forged fee changes move no pool balances.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
