---
id: alignedlayerservicemanager-96b6a29d-operator-bls-bn254
format: 2
title: Aligned service manager accepts BN254 BLS quorum signatures quantum can forge
status: confirmed
severity: MEDIUM
justification: 'BN254 BLS keys fall to a quantum attacker; only an upgrade by the admin to post-quantum attestations
  fixes it: MEDIUM.'
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x96b6a29d7b98519ae66e6398bd27a76b30a5dc3f'
  name: AlignedLayerServiceManager
  project: aligned
  code: verified
  code_url: https://etherscan.io/address/0x32112b2c1a2cd002a8468fcd556e9010cd817ea1#code
  proxy_of: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  copies: 1
  upgradeable: 'yes'
  admin: '0x0d16a82be664c337c615499f8775ef0431703dac'
value:
  usd: 22
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade to verify a post-quantum operator attestation, or pause batch responses until then.
evidence_level: source
checks:
- id: c1
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 109
  has: success := staticcall(sub(gas(), 2000), 6, input, 0x80, r, 0x40)
  says: BN254 point addition via precompile 6
  for:
  - evidence-2
- id: c2
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 176
  has: success := staticcall(sub(gas(), 2000), 7, input, 0x60, r, 0x40)
  says: BN254 scalar multiplication via precompile 7
  for:
  - evidence-2
- id: c3
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 192
  has: function pairing(
  says: BN254 pairing function is defined
  for:
  - what
- id: c5
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 262
  has: success := staticcall(pairingGas, 8, input, mul(12, 0x20), out, 0x20)
  says: safePairing calls the BN254 pairing precompile 8
  for:
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/permissions/Pausable.sol
  line: 73
  has: function pause(uint256 newPausedStatus) external onlyPauser {
  says: pauser can pause contract functions
  for:
  - action
  - evidence-3
- id: c7
  source: '0x32112b2c1a2cd002a8468fcd556e9010cd817ea1'
  file: lib/eigenlayer-middleware/lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
  line: 74
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: ownership is transferable by the owner, showing admin control
  for:
  - action
  - justification
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

This Aligned service manager checks operator BLS signatures on BN254 with the pairing precompile before treating a proof batch as verified. A quantum attacker who recovers operators' BLS keys, and the aggregator's ECDSA key, could have false proof batches marked verified.

## Evidence

- [safePairing](https://etherscan.io/address/0x32112b2c1a2cd002a8468fcd556e9010cd817ea1#code) calls the BN254 pairing precompile to check the aggregate BLS signature.
- [scalar_mul](https://etherscan.io/address/0x32112b2c1a2cd002a8468fcd556e9010cd817ea1#code) and plus build the aggregate key with BN254 curve precompiles.
- [pause](https://etherscan.io/address/0x32112b2c1a2cd002a8468fcd556e9010cd817ea1#code) lets the pauser registry stop functions as a stop gap.

## Reviewer notes

### Mechanism

Per kev's finding, respondToTaskV2 (onlyAggregator) calls BLSSignatureChecker.checkSignatures. That function builds the quorum aggregate public key minus non-signers using BN254.plus (line 109) and scalar_mul (line 176), then verifies the signature via BN254.safePairing (line 262, pairing precompile 0x08). If signed stake meets the 67% threshold, the batch is marked responded, and verifyBatchInclusion returns true for its Merkle leaves. A quantum computer recovers BLS secret keys from the registered BN254 public keys. The aggregator gate is a single ECDSA EOA. Pausable.pause (line 73) offers a stop gap. Replacing the scheme needs a new implementation installed through the proxy admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This deployment shows no calls in the study window and holds little ETH.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
