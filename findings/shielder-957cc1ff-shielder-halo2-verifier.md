---
id: shielder-957cc1ff-shielder-halo2-verifier
format: 2
title: Shielder privacy pool accepts proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on a BN254 KZG pairing; the owner Safe can upgrade the UUPS proxy to post-quantum verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x957cc1ff4e27b400a53139516b66b6739d4905a8'
  name: Shielder
  project: cardinal-cryptography
  code: verified
  code_url: https://etherscan.io/address/0x52aff19891c7d882e14353b4fc0ae25cca810812#code
  proxy_of: '0x52aff19891c7d882e14353b4fc0ae25cca810812'
  copies: 1
  upgradeable: 'yes'
  admin: '0x9dc4e0e4f6d9693e5760227469c0b8cf9a432165'
value:
  usd: 858
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade the proxy to verifiers using a hash-based proof system and pause withdrawals if the KZG setup is
  threatened.
evidence_level: source
checks:
- id: c1
  source: '0x52aff19891c7d882e14353b4fc0ae25cca810812'
  file: contracts/DepositVerifier.sol
  line: 69
  has: function verifyProof(
  says: DepositVerifier defines verifyProof taking a proof and instances.
  for:
  - what
- id: c6
  source: '0x52aff19891c7d882e14353b4fc0ae25cca810812'
  file: contracts/DepositVerifier.sol
  line: 206
  has: ret := and(success, staticcall(gas(), 0x08, 0x00, 0x180, 0x00, 0x20))
  says: The verifier's ec_pairing calls the BN254 pairing precompile 0x08.
  for:
  - evidence-1
  - justification
  - what
- id: c9
  source: '0x52aff19891c7d882e14353b4fc0ae25cca810812'
  file: contracts/Shielder.sol
  line: 160
  has: function pause() external onlyOwner {
  says: pause() is restricted to the owner.
  for:
  - action
  - evidence-3
  - justification
- id: c12
  source: '0x52aff19891c7d882e14353b4fc0ae25cca810812'
  file: node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol
  line: 92
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: upgradeToAndCall exists to replace the implementation behind the proxy.
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
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

Shielder holds deposited funds as notes and pays out against Halo2 proofs checked by a KZG pairing on BN254. With the setup trapdoor recovered by a quantum computer, an attacker forges proofs for notes that do not exist and withdraws the pool.

## Evidence

- [ec_pairing](https://etherscan.io/address/0x52aff19891c7d882e14353b4fc0ae25cca810812#code) calls precompile 0x08 against fixed G2 setup points to accept a proof.
- [upgradeToAndCall](https://etherscan.io/address/0x52aff19891c7d882e14353b4fc0ae25cca810812#code) lets the owner swap in a new implementation.
- [pause](https://etherscan.io/address/0x52aff19891c7d882e14353b4fc0ae25cca810812#code) is owner-only and lets the owner halt the pool.

## Reviewer notes

### Mechanism

withdrawNative/withdrawERC20 (whenNotPaused) call _withdraw, which checks the Merkle root and nullifier, builds public inputs and requires WithdrawVerifier.verifyProof(proof, publicInputs) before transferring the amount minus fees. Deposit and new-account paths use DepositVerifier and NewAccountVerifier the same way. Each verifier is a generated Halo2Verifier library: verifyProof (line 69) accumulates points with precompiles 0x06/0x07 and ends in ec_pairing (line 206), a 0x08 pairing against hard-coded G2 and -s*G2 points from the KZG setup. Knowing s (via discrete log on BN254) allows forging openings and thus valid proofs for arbitrary statements. The implementation sits behind a UUPS proxy; upgradeToAndCall is gated by onlyOwner via _authorizeUpgrade, and pause() is onlyOwner.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
