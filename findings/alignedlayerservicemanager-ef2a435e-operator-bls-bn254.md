---
id: alignedlayerservicemanager-ef2a435e-operator-bls-bn254
format: 2
title: Aligned service manager trusts BN254 BLS keys that a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: 'Batch verification rests on BN254 BLS pairings; Aligned''s 5-of-8 Safe can fix it by upgrading the
  proxy: MEDIUM.'
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xef2a435e5ee44b2041100ef8cbc8ae035166606c'
  name: AlignedLayerServiceManager
  project: aligned
  code: verified
  code_url: https://etherscan.io/address/0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8#code
  proxy_of: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  copies: 1
  upgradeable: 'yes'
  admin: '0x487e0347b96be3606845a3aadc7b0d8138952b47'
value:
  usd: 1712
  basis: held
activity:
  txs_90d: 5
impact: funds-loss
action: Upgrade the service manager to verify post-quantum operator attestations and move the aggregator gate off
  a single ECDSA key.
evidence_level: source
checks:
- id: c1
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 109
  has: success := staticcall(sub(gas(), 2000), 6, input, 0x80, r, 0x40)
  says: BN254 point addition via precompile 6
  for:
  - evidence-2
- id: c2
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 176
  has: success := staticcall(sub(gas(), 2000), 7, input, 0x60, r, 0x40)
  says: BN254 scalar multiplication via precompile 7
  for:
  - evidence-2
- id: c3
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 192
  has: function pairing(
  says: BN254 pairing function
  for:
  - what
- id: c4
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 218
  has: success := staticcall(sub(gas(), 2000), 8, input, mul(12, 0x20), out, 0x20)
  says: pairing calls precompile 8
  for:
  - justification
- id: c5
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 262
  has: success := staticcall(pairingGas, 8, input, mul(12, 0x20), out, 0x20)
  says: safePairing calls BN254 pairing precompile 8
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8'
  file: lib/eigenlayer-middleware/lib/eigenlayer-contracts/src/contracts/permissions/Pausable.sol
  line: 73
  has: function pause(uint256 newPausedStatus) external onlyPauser {
  says: pauser can pause functionality
  for:
  - evidence-3
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

The service manager marks proof batches as verified after a BN254 pairing check of the operators' aggregate BLS signature. A quantum attacker who recovers the operators' BLS keys and the aggregator's ECDSA key can mark false proofs as verified for contracts that trust it.

## Evidence

- [safePairing](https://etherscan.io/address/0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8#code) calls the BN254 pairing precompile to check the aggregate signature.
- [plus and scalar_mul](https://etherscan.io/address/0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8#code) build the aggregate key with BN254 curve precompiles.
- [pause](https://etherscan.io/address/0x4a5d61aba7d845bc71d4e2f2dd7c35d9c5fb55b8#code) lets a pauser stop functions as a stop gap.

## Reviewer notes

### Mechanism

respondToTaskV2 (AlignedLayerServiceManager line 152, onlyAggregator line 369) calls BLSSignatureChecker.checkSignatures (line 192), which subtracts non-signer keys from the quorum APK using BN254.plus/scalar_mul (BN254.sol lines 109, 176) and runs trySignatureAndApkVerification -> BN254.safePairing (line 262). It then requires at least 67% of quorum-0 stake, sets responded = true and pays the aggregator from the batcher balance, capped by respondToTaskFeeLimit. verifyBatchInclusion (lines 256, 302) returns true for any leaf of a responded batch. BN254 BLS keys follow from public keys with a quantum computer; the aggregator is an ECDSA EOA. Fix is an implementation upgrade via ProxyAdmin owned by a 5-of-8 Safe; pause bit 1 is a stop gap.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Batcher deposits leave only as capped per-batch aggregator fees; withdraw pays the batcher itself.
- Ruled out: The only on-chain consumer seen, a demo VoteInbox, holds nothing.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
