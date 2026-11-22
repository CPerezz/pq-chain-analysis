---
id: blsapkregistry-33ade04d-finality-bls-bn254
format: 2
title: Manta finality registry accepts BN254 quorums a quantum attacker could forge
status: confirmed
severity: LOW
justification: BN254 BLS falls to a quantum attacker; LOW because the oracle it feeds is read by no portal and nothing
  is held.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x33ade04d39283dd7105e2961621f204a5bc2620d'
  name: BLSApkRegistry
  project: manta
  code: verified
  code_url: https://etherscan.io/address/0x2423a4a6e9020fec543e46f27fcb1806a569d002#code
  proxy_of: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  copies: 1
  upgradeable: 'yes'
  admin: '0xcfd3871e84d84d2b2ec74e1ca728abcef05081ff'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Replace BLS attestations with a post-quantum scheme in a new implementation before any portal-read oracle
  relies on this registry.
evidence_level: source
checks:
- id: c1
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/bls/BLSApkRegistry.sol
  line: 110
  has: BN254.pairing(
  says: key registration checks a BN254 pairing
  for:
  - evidence-3
- id: c5
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/libraries/BN254.sol
  line: 192
  has: success := staticcall(sub(gas(), 2000), 8, input, mul(12, 0x20), out, 0x20)
  says: pairing calls the BN254 pairing precompile
  for:
  - justification
- id: c6
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/libraries/BN254.sol
  line: 236
  has: success := staticcall(pairingGas, 8, input, mul(12, 0x20), out, 0x20)
  says: safePairing calls the BN254 pairing precompile
  for:
  - evidence-2
  - what
- id: c7
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
  line: 102
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: the owner can act on the contract (ownership control)
  for:
  - action
- id: s-check
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/bls/BLSApkRegistry.sol
  has: 'require(signatureIsValid, "BLSSignatureChecker.checkSignatures: signature is invalid");'
  line: 150
  says: checkSignatures reverts unless the pairing says the signature is valid
  for:
  - evidence-1
  - justification
  - what
- id: s-try
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/bls/BLSApkRegistry.sol
  has: (pairingSuccessful, siganatureIsValid) = BN254.safePairing(
  line: 178
  says: verification uses BN254 safePairing
  for:
  - evidence-2
  - what
- id: s-apk
  source: '0x2423a4a6e9020fec543e46f27fcb1806a569d002'
  file: src/bls/BLSApkRegistry.sol
  has: signerApk = currentApk.plus(params.nonSignerPubkeys[j].negate());
  line: 142
  says: aggregate signer key is derived from registered public keys
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

This registry holds Manta finality operators' BN254 BLS keys and accepts a quorum signature when a pairing check passes. A quantum attacker who recovers operator secret keys from their public keys can forge a passing quorum for any message.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x2423a4a6e9020fec543e46f27fcb1806a569d002#code) reverts unless the BN254 pairing over the signer aggregate key reports the signature valid.
- [trySignatureAndApkVerification](https://etherscan.io/address/0x2423a4a6e9020fec543e46f27fcb1806a569d002#code) runs the pairing precompile through safePairing.
- [registerBLSPublicKey](https://etherscan.io/address/0x2423a4a6e9020fec543e46f27fcb1806a569d002#code) checks key possession with a BN254 pairing.

## Reviewer notes

### Mechanism

checkSignatures (BLSApkRegistry.sol lines 128-158) builds signerApk from currentApk minus non-signer keys (line 142). It then calls trySignatureAndApkVerification (line 165), which calls BN254.safePairing (line 178; precompile 8 at BN254.sol line 236), and requires signatureIsValid (line 150). Keys are registered via registerBLSPublicKey with a pairing proof of possession (line 110). Per the finding, FinalityRelayerManager 0x3df6605c calls checkSignatures and then shortens the finalization period of L2OutputOracle 0x9dac8be6. Manta Pacific's portal reads oracle 0x30c78967, so a forged quorum shortens no live withdrawal window. Last activity 2025-08-28; the registry holds nothing. It is upgradeable by owner EOA 0x4e3321e3 via ProxyAdmin 0xcfd3871e.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No funds held by the registry
- Ruled out: Target oracle is not read by Manta Pacific's portal

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
