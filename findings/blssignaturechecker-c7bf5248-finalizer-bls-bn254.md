---
id: blssignaturechecker-c7bf5248-finalizer-bls-bn254
format: 2
title: Gasp finalizer accepts BLS quorum signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 BLS keys fall to a quantum computer; the task manager's owner Safe can point it at a new checker,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc7bf5248bd4e4e618b01414600d48530e677ca0d'
  name: BLSSignatureChecker
  project: gasp
  code: verified
  code_url: https://etherscan.io/address/0xc7bf5248bd4e4e618b01414600d48530e677ca0d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Point the finalizer task manager at a post-quantum attestation checker, or upgrade the task manager.
evidence_level: source
checks:
- id: c5
  source: '0xc7bf5248bd4e4e618b01414600d48530e677ca0d'
  file: lib/eigenlayer-middleware/src/libraries/BN254.sol
  line: 262
  has: success := staticcall(pairingGas, 8, input, mul(12, 0x20), out, 0x20)
  says: safePairing calls the BN254 pairing precompile 0x08
  for:
  - evidence-2
  - justification
  - what
- id: cs-check
  source: '0xc7bf5248bd4e4e618b01414600d48530e677ca0d'
  file: lib/eigenlayer-middleware/src/BLSSignatureChecker.sol
  has: function checkSignatures(
  line: 88
  says: checkSignatures entry point for aggregate operator signatures
  for:
  - action
  - what
- id: cs-pair
  source: '0xc7bf5248bd4e4e618b01414600d48530e677ca0d'
  file: lib/eigenlayer-middleware/src/BLSSignatureChecker.sol
  has: (pairingSuccessful, siganatureIsValid) = BN254.safePairing(
  line: 327
  says: signature verified with a BN254 pairing
  for:
  - evidence-2
  - justification
  - what
- id: cs-valid
  source: '0xc7bf5248bd4e4e618b01414600d48530e677ca0d'
  file: lib/eigenlayer-middleware/src/BLSSignatureChecker.sol
  has: signatureIsValid,
  line: 282
  says: the check requires the BLS signature to be valid
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
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

This contract checks that Gasp finalizer operators holding enough stake signed a message, using a BN254 BLS aggregate signature verified by a pairing. A quantum attacker who derives enough operators' BLS keys can forge a passing quorum signature for a false batch.

## Evidence

- [checkSignatures](https://etherscan.io/address/0xc7bf5248bd4e4e618b01414600d48530e677ca0d#code) rejects a batch unless the aggregate BLS signature is valid.
- [trySignatureAndApkVerification](https://etherscan.io/address/0xc7bf5248bd4e4e618b01414600d48530e677ca0d#code) verifies the signature with a BN254 pairing.

## Reviewer notes

### Mechanism

BLSSignatureChecker.checkSignatures (line 88) builds the signers' aggregate key from the stored quorum APKs minus non-signer keys and sums signed stake. It then calls trySignatureAndApkVerification (line 271), which calls BN254.safePairing (line 327) and the pairing precompile 0x08 (BN254.sol line 262). It requires signatureIsValid (line 282). Gasp's FinalizerTaskManager calls checkSignatures in respondToRdTask (onlyAggregator) and compares the signed stake with the quorum threshold. If the threshold is met, it writes the batch root into Rolldown via update_l1_from_l2, and Rolldown pays withdrawals proven against that root. BLS secret keys follow from the public keys, so a quantum attacker who also acts as the aggregator can post a false root. The task manager owner can replace the checker through updateBlsSignatureCheckerAddress.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This checker holds no funds itself.
- Ruled out: Rotating operator BLS keys does not fix it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
