---
id: honkverifier-14dacd53-honk-verifier
format: 2
title: Payy rollup verifier accepts pairing proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged KZG proofs pass one rollup gate; MEDIUM since Payy's owner Safe can swap in a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  name: HonkVerifier
  project: payy
  code: verified
  code_url: https://etherscan.io/address/0x14dacd534ddc676601b27f41eb541a7951524a2f#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 273
impact: funds-loss
action: Deploy a post-quantum verifier for the rollup circuit and switch RollupV1 to it, removing this verifier.
evidence_level: source
checks:
- id: c3
  source: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  file: agg_final.sol
  line: 1842
  has: function pairing(Honk.G1Point memory rhs, Honk.G1Point memory lhs) view returns (bool decodedResult) {
  says: The pairing function builds a BN254 pairing input.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  file: agg_final.sol
  line: 2330
  has: return pairing(pair.P_0, pair.P_1);
  says: Verification returns the result of the pairing check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  file: agg_final.sol
  line: 2417
  has: success := and(success, staticcall(gas(), 7, add(free, 0x40), 0x60, add(free, 0x40), 0x40))
  says: batchMul calls the ecMul precompile.
  for:
  - evidence-3
  - what
- id: c6
  source: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  file: agg_final.sol
  line: 2419
  has: success := and(success, staticcall(gas(), 6, free, 0x80, free, 0x40))
  says: batchMul calls the ecAdd precompile.
  for:
  - evidence-3
- id: g2vk
  source: '0x14dacd534ddc676601b27f41eb541a7951524a2f'
  file: agg_final.sol
  has: // G2 point from VK
  line: 1853
  says: The pairing uses a G2 point taken from the setup's verification key.
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
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This HonkVerifier checks Payy rollup proofs with a KZG pairing check over BN254, using a fixed setup point. A quantum attacker who recovers the setup trapdoor can forge proofs that pass this verifier.

## Evidence

- [verify](https://etherscan.io/address/0x14dacd534ddc676601b27f41eb541a7951524a2f#code) ends by returning the result of a BN254 pairing check.
- [pairing](https://etherscan.io/address/0x14dacd534ddc676601b27f41eb541a7951524a2f#code) checks the proof against a fixed G2 point from the verification key.
- [batchMul](https://etherscan.io/address/0x14dacd534ddc676601b27f41eb541a7951524a2f#code) combines the proof commitments with BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

RollupV1.verifyRollup calls zkVerifiers[key].verifier.verify(aggrProof, publicInputs), which points to this HonkVerifier. Here, the verifier batches the commitments with batchMul (lines 2390-2428), using ecMul and ecAdd precompiles 7 and 6. It aggregates the result with the proof's pairing point object (lines 2318-2328) and returns pairing(P_0, P_1) (line 2330). That function (lines 1842-1861) calls precompile 0x08 with a fixed G2 generator and the verification key's G2 point (lines 1854-1857). Anyone who knows the trusted-setup trapdoor, which a quantum computer can recover from the public setup points, can produce commitments that satisfy this check for false public inputs. Even so, a forged root also needs the ECDSA prover and validator checks in RollupV1 to pass.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The retired verifier 0xb553c325 is not enabled in the rollup.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
