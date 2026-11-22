---
id: blsapkregistry-a80f2401-finality-bls-bn254
format: 2
title: Manta BLSApkRegistry accepts BN254 BLS quorums a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forgeable BLS, but the oracle hook it fed is removed and it holds nothing; the EOA owner can upgrade
  it.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa80f2401c8ae7d95c7995295dc2c0d651f25fd60'
  name: BLSApkRegistry
  project: manta
  code: verified
  code_url: https://etherscan.io/address/0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f#code
  proxy_of: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  copies: 1
  upgradeable: 'yes'
  admin: '0xab64a3da57886cd4205176c72b8be63c34e46366'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Move operator attestations to a post-quantum scheme in a new implementation before re-enabling the finality
  shortcut.
evidence_level: source
checks:
- id: c1
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: src/bls/BLSApkRegistry.sol
  line: 110
  has: BN254.pairing(
  says: key registration verifies a BN254 pairing
  for:
  - evidence-3
  - what
- id: c6
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: src/libraries/BN254.sol
  line: 236
  has: success := staticcall(pairingGas, 8, input, mul(12, 0x20), out, 0x20)
  says: safePairing calls the BN254 pairing precompile
  for:
  - evidence-2
  - justification
  - what
- id: c7
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
  line: 102
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: the contract has an owner with admin powers
  for:
  - action
  - justification
- id: chk-sig
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: src/bls/BLSApkRegistry.sol
  has: function checkSignatures(bytes32 msgHash
  line: 128
  says: checkSignatures is the quorum signature check
  for:
  - evidence-1
  - what
- id: chk-pair
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: src/bls/BLSApkRegistry.sol
  has: BN254.safePairing(
  line: 178
  says: signature verification is a BN254 pairing
  for:
  - evidence-2
  - what
- id: chk-valid
  source: '0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f'
  file: src/bls/BLSApkRegistry.sol
  has: require(signatureIsValid
  line: 150
  says: an invalid pairing result reverts
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0xa80f2401
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review21 (0xa80f2401 registry, manager and Manta Pacific L2OutputOracle reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This registry checks BN254 BLS quorum signatures from Manta's finality operators for the FinalityRelayerManager. A quantum attacker who recovers operator BLS keys from their public keys can forge a quorum that passes the pairing check.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f#code) accepts a quorum only if the BN254 pairing verifies.
- [trySignatureAndApkVerification](https://etherscan.io/address/0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f#code) runs the pairing precompile on the aggregate key.
- [registerBLSPublicKey](https://etherscan.io/address/0x8ad2384aaf9525bd7b4d3f73e8cc07421af2046f#code) checks key possession with a BN254 pairing.

## Reviewer notes

### Mechanism

FinalityRelayerManager.VerifyFinalitySignature calls BLSApkRegistry.checkSignatures (lines 128-158). That function subtracts non-signer keys from currentApk (line 142) and calls trySignatureAndApkVerification (line 147, defined at line 165). The verification uses BN254.safePairing, which calls precompile 8 (BN254.sol line 236). It requires signatureIsValid (line 150). registerBLSPublicKey checks proof of possession via BN254.pairing (line 110). Recovering BLS secret keys forges any quorum. The manager then calls the L2OutputOracle's proposalChangeFinalizationPeriodSeconds. Manta Pacific's current oracle implementation has removed that hook, so the call reverts. The contract is upgradeable by its ProxyAdmin, owned by an EOA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Holds no ETH or tokens.
- Ruled out: Oracle hook removed in Manta Pacific's current L2OutputOracle, so the withdrawal window cannot be shortened.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
