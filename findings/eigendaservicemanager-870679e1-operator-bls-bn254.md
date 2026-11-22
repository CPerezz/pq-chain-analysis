---
id: eigendaservicemanager-870679e1-operator-bls-bn254
format: 2
title: EigenDA ServiceManager certifies batches on BLS keys quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: BN254 BLS quorum signatures fall to a quantum attacker; MEDIUM because the owner Safe can upgrade
  the verifier.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x870679e138bcdf293b7ff14dd44b70fc97e12fc0'
  name: EigenDAServiceManager
  project: eigenda
  code: verified
  code_url: https://etherscan.io/address/0xae448d008b6f69033afda361b46b36c472b6fee0#code
  proxy_of: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  copies: 1
  upgradeable: 'yes'
  admin: '0x8247ef5705d3345516286b72bfe6d690197c2e99'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18
impact: funds-locked
action: Upgrade the ServiceManager to verify post-quantum aggregate certificates and let operators register post-quantum
  keys.
evidence_level: source
checks:
- id: c1
  source: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 109
  has: success := staticcall(sub(gas(), 2000), 6, input, 0x80, r, 0x40)
  says: BN254.plus adds curve points with the ecAdd precompile.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 176
  has: success := staticcall(sub(gas(), 2000), 7, input, 0x60, r, 0x40)
  says: BN254.scalar_mul uses the ecMul precompile.
  for:
  - evidence-2
  - what
- id: c3
  source: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 192
  has: function pairing(
  says: BN254 library defines the pairing check used for BLS signatures.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 218
  has: success := staticcall(sub(gas(), 2000), 8, input, mul(12, 0x20), out, 0x20)
  says: pairing calls the BN254 pairing precompile (address 8).
  for:
  - evidence-1
  - justification
  - what
- id: c7
  source: '0xae448d008b6f69033afda361b46b36c472b6fee0'
  file: lib/eigenlayer-middleware/lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
  line: 74
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: Ownership is held by an owner who can act on the contract.
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
  who: review (Review12)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

The ServiceManager records data-availability batches after checking an aggregate BLS signature on the BN254 curve through the pairing precompile. A quantum attacker who recovers operator BLS keys and a batch-confirmer key can certify data no operator stores, for rollups that read these certificates.

## Evidence

- [pairing](https://etherscan.io/address/0xae448d008b6f69033afda361b46b36c472b6fee0#code) checks BLS signatures with the BN254 pairing precompile.
- [plus and scalar_mul](https://etherscan.io/address/0xae448d008b6f69033afda361b46b36c472b6fee0#code) combine BN254 public keys with the elliptic-curve precompiles.

## Reviewer notes

### Mechanism

confirmBatch (EigenDAServiceManager.sol lines 88-140, onlyBatchConfirmer, tx.origin == msg.sender) hashes the reduced batch header and calls BLSSignatureChecker.checkSignatures. That subtracts non-signer keys from stored quorum aggregate keys via BN254.plus (ecAdd precompile, line 109) and BN254.scalar_mul (ecMul precompile, line 176), then checks the aggregate signature with the BN254 pairing precompile (BN254.pairing line 218 / safePairing line 262). If each quorum's signed stake meets its threshold, it stores batchIdToBatchMetadataHash[batchId] and emits BatchConfirmed; V1 blob certificates are verified against that hash. Operator BLS public keys are on-chain, so a quantum attacker derives the secret keys, and the batch confirmer is an EOA whose key is also recoverable. The implementation sits behind a proxy whose ProxyAdmin and owner are a 2-of-4 Safe that can upgrade it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: EigenDA V2 certificate verifiers were not checked.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
