---
id: zksyncosdualverifier-da5e793b-plonk-fflonk-verifier
format: 2
title: ZKsync OS verifier relies on BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: With the BN254 setup trapdoor, forged batch proofs pass; the owner, Matter Labs' Governance, can
  swap the leg.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xda5e793b8ae713241d5cb681fd987704e59f7459'
  name: ZKsyncOSDualVerifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0xda5e793b8ae713241d5cb681fd987704e59f7459#code
  copies: 1
  upgradeable: 'no'
  admin: '0xc66f0b45c05cf654eec093650fd67865e85e8566'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1597
impact: funds-loss
action: Swap the BN254 PLONK leg for a post-quantum verifier of the underlying STARK proof.
evidence_level: source
checks:
- id: c1
  source: '0xda5e793b8ae713241d5cb681fd987704e59f7459'
  file: lib/openzeppelin-contracts-v4/contracts/access/Ownable2Step.sol
  line: 35
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: Ownership transfer is owner-only and done in two steps.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xda5e793b8ae713241d5cb681fd987704e59f7459'
  file: lib/openzeppelin-contracts-v4/contracts/access/Ownable.sol
  line: 69
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: transferOwnership in Ownable is restricted to the owner.
  for:
  - evidence-2
  - what
- id: code
  code: '0xda5e793b8ae713241d5cb681fd987704e59f7459'
  is: contract
  bytes: 4203
  says: The address holds deployed contract code.
  for:
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

This contract checks batch proofs for ZKsync OS chains by passing them to a BN254 PLONK verifier leg. A quantum attacker with the setup trapdoor can forge a proof that this leg accepts. The contract has an owner, who controls it through a two-step ownership transfer.

## Evidence

- [transferOwnership](https://etherscan.io/address/0xda5e793b8ae713241d5cb681fd987704e59f7459#code) is owner-gated and starts a two-step handover of control.
- [Ownable](https://etherscan.io/address/0xda5e793b8ae713241d5cb681fd987704e59f7459#code) restricts transferOwnership to the current owner.

## Reviewer notes

### Mechanism

Batches of ZKsync OS chains are verified through this ZKsyncOSDualVerifier (Ownable2Step). Its verify function hashes the public inputs and routes proof type 2 to plonkVerifiers[version]. Versions 0 and 6 point to the BN254 PLONK leg 0x433fe66e. That leg checks the proof with the ecAdd/ecMul/ecPairing precompiles, which rely on a trusted-setup trapdoor. A quantum attacker who recovers the trapdoor can forge a proof for a false batch whose L2-to-L1 logs authorise withdrawals from the shared L1NativeTokenVault, up to the chain's balance. The owner can add and remove verifier legs. Ownership is managed through Ownable2Step.transferOwnership (line 35) and Ownable.onlyOwner (line 69).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable through a proxy.
- Ruled out: The contract itself holds no funds.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
