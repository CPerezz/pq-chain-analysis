---
id: honkverifier-77e3ba09-honk-verifier
format: 2
title: Aztec rollup v0 verifier accepts BN254 KZG proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 trusted setup; Aztec Governance fixes it by registering a rollup with a hash-based
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x77e3ba096355510e0e9f60d292010b42d662d2b5'
  name: HonkVerifier
  project: aztec
  code: verified
  code_url: https://etherscan.io/address/0x77e3ba096355510e0e9f60d292010b42d662d2b5#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Register a rollup version whose epoch proofs are checked by a hash-based verifier, and move users to it.
evidence_level: source
checks:
- id: c3
  source: '0x77e3ba096355510e0e9f60d292010b42d662d2b5'
  file: lib/l1-contracts/src/HonkVerifier.sol
  line: 1790
  has: function pairing(Honk.G1Point memory rhs, Honk.G1Point memory lhs) view returns (bool decodedResult) {
  says: pairing checks against a fixed G2 setup point via BN254
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x77e3ba096355510e0e9f60d292010b42d662d2b5'
  file: lib/l1-contracts/src/HonkVerifier.sol
  line: 2240
  has: return pairing(P_0_agg, P_1_agg);
  says: verify's result is the BN254 pairing check
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x77e3ba096355510e0e9f60d292010b42d662d2b5'
  file: lib/l1-contracts/src/HonkVerifier.sol
  line: 2270
  has: success := and(success, staticcall(gas(), 7, add(free, 0x40), 0x60, add(free, 0x40), 0x40))
  says: batchMul uses BN254 ecMul precompile
  for:
  - evidence-2
- id: c6
  source: '0x77e3ba096355510e0e9f60d292010b42d662d2b5'
  file: lib/l1-contracts/src/HonkVerifier.sol
  line: 2272
  has: success := and(success, staticcall(gas(), 6, free, 0x80, free, 0x40))
  says: batchMul uses BN254 ecAdd precompile
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review00 (verified source of the three verifiers and their rollups; Registry, GSE and portal reads; Xatu
    activity)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This HonkVerifier checks Aztec rollup version 0 epoch proofs with a single BN254 pairing against a fixed G2 setup point. A quantum attacker who recovers the setup trapdoor can make a false proof pass this check.

## Evidence

- [pairing](https://etherscan.io/address/0x77e3ba096355510e0e9f60d292010b42d662d2b5#code) checks the proof with the BN254 pairing precompile against a fixed G2 point.
- [batchMul](https://etherscan.io/address/0x77e3ba096355510e0e9f60d292010b42d662d2b5#code) builds the KZG opening claim with the BN254 ecMul and ecAdd precompiles.

## Reviewer notes

### Mechanism

The verify function in BaseHonkVerifier runs the Shplemini batch opening. batchMul (lines 2243-2281) aggregates the commitments with the ecMul and ecAdd precompiles (lines 2270 and 2272). The result is folded with the proof's pairing point object by mulWithSeperator (lines 2237-2238). At line 2240 the function returns pairing(P_0_agg, P_1_agg). pairing (line 1790) calls precompile 0x08 against a fixed G2 point from the verification key (lines 1801-1805). If the trapdoor of that KZG setup is known, forged quotient commitments satisfy this check. This verifier serves rollup version 0, which is halted: its proven and pending block are equal and it has no attesters, so there is nothing left to prove today.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Rollup version 0 is halted and its FeeJuicePortal is empty, so this verifier currently guards no funds.
- Ruled out: No verifier setter exists; the rollup fixed it at construction.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
