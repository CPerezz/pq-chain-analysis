---
id: contract-01c344b8-bls-bn254
format: 2
title: Drosera trap claims rest on BLS operator keys a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: False claims trigger protected protocols' responses; the owner Safe can route claims to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x01c344b8406c3237a6b9dbd06ef2832142866d87'
  project: drosera
  code: decompiled
  code_url: code/0x1fece1258a5fba896e5722f820e53a958ba37aeeeebcaba7c1ce51f72c34f8b1.sol
  copies: 1
  admin: '0xf5cd89a836860a6e634785a3244a745990248935'
value:
  usd: 65
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Route the claim selector to an implementation that verifies operator attestations with post-quantum signatures.
evidence_level: bytecode
checks:
- id: code
  code: '0x01c344b8406c3237a6b9dbd06ef2832142866d87'
  is: contract
  bytes: 839
  says: the router address holds contract code
  for:
  - evidence-1
  - justification
  - what
- id: sel-owner
  selector: '0x01c344b8406c3237a6b9dbd06ef2832142866d87'
  fn: owner()
  says: router has an owner
  for:
  - action
  - evidence-2
  - justification
- id: sel-transfer
  selector: '0x01c344b8406c3237a6b9dbd06ef2832142866d87'
  fn: transferOwnership(address)
  says: owner can hand over control
  for:
  - action
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Drosera router accepts trap claims on a BN254 pairing check of operator BLS signatures. With recovered operator keys, a quantum attacker submits false claims that trigger protected protocols' responses.

## Evidence

- [Claim transaction](https://etherscan.io/tx/0xa7a26fca6e55035eaf9afd617ba37a7b0357abdd8f13aac2412634d63dda311b) passes a G1 and a G2 point, invokes the trap's response and emits ClaimSubmitted.
- [The router](https://etherscan.io/address/0x01c344b8406c3237a6b9dbd06ef2832142866d87#code) exposes owner() and transferOwnership, so its owner controls upgrades.

## Reviewer notes

### Mechanism

The 839-byte router looks up an implementation for msg.sig and DELEGATECALLs it. For claim selector 0x96051d56 it delegates to 0xd569cb69. That implementation takes the trap address, block number, two hashes, a G1 point and a G2 point. It runs one two-pair ecpairing (precompile 0x08, 0x180-byte input) against operator keys registered at opt-in (OperatorOptedIntoTrap). It then calls the trap config (ClaimMade, ResponseFunctionInvoked), pays operators through sDRO and emits ClaimSubmitted. Forged BLS signatures from recovered keys pass this check. The owner, a 2-of-7 Safe, controls routing through the Ownable functions.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a SNARK verifier: the pairing input is BLS-shaped (two pairs).
- Ruled out: Value held by the router is small; the stake is what the trap responses do.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
