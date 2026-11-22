---
id: eraverifierfflonk-870c0a2b-plonk-fflonk-verifier
format: 2
title: ZKsync EraVerifierFflonk accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pairing-based proofs fall to a quantum attacker; ZKsync governance can repoint chains to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  name: EraVerifierFflonk
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x870c0a2bd4f253dd867b2239a0d8d86f87d64128#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1011
impact: funds-loss
action: Repoint chains to a verifier that checks the hash-based STARK proof directly, through a protocol upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1501
  has: let success := staticcall(gas(), 7, 0x80, 0x60, 0x80, 0x40)
  says: point_mul uses the BN254 scalar-multiplication precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1520
  has: let success := staticcall(gas(), 6, 0x80, 0x80, 0x80, 0x40)
  says: point_add uses the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x870c0a2bd4f253dd867b2239a0d8d86f87d64128'
  file: contracts/state-transition/verifiers/EraVerifierFflonk.sol
  line: 1576
  has: let success := staticcall(gas(), 8, 0x80, mul(12, 0x20), 0x80, 0x20)
  says: pairing_check uses the BN254 pairing precompile.
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

This contract is the fflonk leg that checks ZK Stack batch proofs with BN254 elliptic-curve operations and a pairing check. With the setup trapdoor, a quantum attacker could make a false batch proof pass this check.

## Evidence

- [pairing_check](https://etherscan.io/address/0x870c0a2bd4f253dd867b2239a0d8d86f87d64128#code) decides proof validity with the BN254 pairing precompile.
- [point_mul and point_add](https://etherscan.io/address/0x870c0a2bd4f253dd867b2239a0d8d86f87d64128#code) combine proof commitments with BN254 precompiles.

## Reviewer notes

### Mechanism

A DualVerifier's verify routes proof type 0 to its immutable FFLONK_VERIFIER, which is this contract. The verifier builds a keccak transcript, combines commitments with point_mul (precompile 7, line 1501), point_add and point_sub (precompile 6, lines 1520 and 1541), and accepts the proof if pairing_check (precompile 8, line 1576) returns true against the verification key's G2 elements. Anyone who knows the BN254 setup trapdoor, which a quantum computer can recover via discrete logarithms, can produce commitments that satisfy the pairing for false public inputs. A false batch then authorises withdrawals from the shared vault.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no admin slot read.
- Ruled out: Holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
