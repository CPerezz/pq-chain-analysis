---
id: l1verifierfflonk-d5dbe903-plonk-fflonk-verifier
format: 2
title: ZKsync fflonk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proofs fall to a quantum attacker; ZKsync governance can repoint chains to a new verifier
  by upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd5dbe903f5382b052317d326fa1a7b63710c6a5b'
  name: L1VerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xd5dbe903f5382b052317d326fa1a7b63710c6a5b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the BN254 wrapper with an on-chain hash-based STARK verifier and repoint chains through a protocol
  upgrade.
evidence_level: source
checks:
- id: c1
  source: '0xd5dbe903f5382b052317d326fa1a7b63710c6a5b'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1484
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul uses the BN254 scalar-multiplication precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd5dbe903f5382b052317d326fa1a7b63710c6a5b'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1503
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add uses the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0xd5dbe903f5382b052317d326fa1a7b63710c6a5b'
  file: contracts/state-transition/verifiers/L1VerifierFflonk.sol
  line: 1559
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check uses the BN254 pairing precompile to accept the proof.
  for:
  - action
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks fflonk batch proofs for ZK Stack chains using BN254 curve additions, multiplications and a pairing check. With the setup trapdoor, a quantum attacker could make it accept a proof of a false batch, including withdrawals that never happened.

## Evidence

- [pairing_check](https://etherscan.io/address/0xd5dbe903f5382b052317d326fa1a7b63710c6a5b#code) decides proof validity with the BN254 pairing precompile.
- [point_mul and point_add](https://etherscan.io/address/0xd5dbe903f5382b052317d326fa1a7b63710c6a5b#code) combine proof commitments with BN254 precompiles.

## Reviewer notes

### Mechanism

L1VerifierFflonk is a fixed-key fflonk verifier used as the fflonk leg of a DualVerifier, which routes proof type 0 to it. The proof is processed with a keccak transcript (update_transcript, get_challenge), then commitments are combined with point_mul (precompile 7, line 1484), point_add/point_sub (precompile 6, lines 1503 and 1524), and the final decision is pairing_check (precompile 8, line 1559) against verification-key G2 elements. Knowing the BN254 setup trapdoor, which a quantum computer can derive from public setup points, lets one build commitments satisfying the pairing for arbitrary public inputs, so the diamond would accept a false batch and its L2-to-L1 withdrawal logs.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy or admin on this contract.
- Ruled out: Contract holds about $0 itself; funds sit in the shared L1 vault.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
