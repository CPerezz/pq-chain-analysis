---
id: zksyncosdualverifier-ccbdfd7f-zk-verifiers
format: 2
title: ADI Chain verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Medium because the owner, ADI governance, can register a post-quantum verifier itself.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39'
  name: ZKsyncOSDualVerifier
  project: adi-chain
  code: verified
  code_url: https://etherscan.io/address/0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39#code
  copies: 1
  upgradeable: 'no'
  admin: '0x8253f33026c49a430963fe3991441c02175bda95'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2772
impact: funds-loss
action: Register a post-quantum verifier with addVerifier and remove the BN254 PLONK leg with removeVerifier.
evidence_level: source
checks:
- id: c2
  source: '0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39'
  file: lib/openzeppelin-contracts-v4/contracts/access/Ownable2Step.sol
  line: 35
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: transferOwnership is owner-only and sets a pending owner.
  for:
  - evidence-2
  - justification
  - what
- id: code
  code: '0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39'
  is: contract
  bytes: 4203
  says: The address holds contract code.
  for:
  - what
- id: s-onlyowner
  source: '0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39'
  file: lib/openzeppelin-contracts-v4/contracts/access/Ownable.sol
  has: modifier onlyOwner() {
  line: 35
  says: Owner-only functions are gated by the onlyOwner modifier.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: s-accept
  source: '0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39'
  file: lib/openzeppelin-contracts-v4/contracts/access/Ownable2Step.sol
  has: function acceptOwnership() public virtual {
  line: 52
  says: A pending owner must accept ownership.
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is ADI Chain's batch proof verifier router. Its owner holds owner-only control over it. Ownership moves in two steps: the current owner names a successor, who must accept.

## Evidence

- [onlyOwner](https://etherscan.io/address/0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39#code) restricts owner functions to the current owner.
- [transferOwnership](https://etherscan.io/address/0xccbdfd7f9a8e60d0c1e79fa620205d14121e7a39#code) sets a pending owner, who must then call acceptOwnership.

## Reviewer notes

### Mechanism

The ADI Chain diamond (getVerifier() = this contract) calls ZKsyncOSDualVerifier.verify(_publicInputs, _proof) when a batch proof is submitted. verify reads the type and version from _proof[0], hashes the public inputs, and for type 2 calls plonkVerifiers[version].verify (line 75). Version 0 is ZKsyncOSVerifierPlonk 0xc1288a84..., which checks the proof with the BN254 precompiles modexp, ecMul, ecAdd and ecPairing. If an attacker knows the setup trapdoor, which a quantum computer can recover, they can make a false batch pass, including withdrawals that never happened. Those withdrawals are paid from the chain's L1NativeTokenVault. The owner (Governance 0x8253f330..., through Ownable2Step: onlyOwner at Ownable.sol line 35, transferOwnership at Ownable2Step.sol line 35) can call addVerifier and removeVerifier to replace the leg.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The registered fflonk leg is not reachable through verify.
- Ruled out: The contract is not a proxy and holds no funds itself.
- Ruled out: The DA validator makes no KZG point-evaluation call.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
