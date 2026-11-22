---
id: sgxverifier-9e322fc5-sgx-instance-keys
format: 2
title: Taiko Pacaya SGX verifier trusts ECDSA keys a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Proofs rest on ECDSA instance keys; the Taiko DAO can fix it by upgrading the verifier, no protocol
  change.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9e322fc59b8f4a29e6b25c3a166ac1892aa30136'
  name: SgxVerifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5#code
  proxy_of: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  copies: 1
  upgradeable: 'yes'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade or retire this verifier so proofs no longer rest on ECDSA instance keys.
evidence_level: source
checks:
- id: c1
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  line: 180
  has: require(oldInstance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  says: verifyProof accepts a proof only if ECDSA recovers the instance address.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover relies on the ecrecover precompile (secp256k1).
  for:
  - what
- id: c4
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 68
  has: function upgradeTo(address newImplementation) public virtual onlyProxy {
  says: The contract is UUPS-upgradeable.
  for:
  - action
  - evidence-3
  - justification
- id: only-callers
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: onlyFromEither(taikoInbox, taikoProofVerifier)
  line: 153
  says: Only the inbox or proof verifier can call verifyProof.
  for:
  - what
- id: inst-valid
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: require(_isInstanceValid(id, oldInstance), SGX_INVALID_INSTANCE());
  line: 183
  says: The signer must be a registered, unexpired instance.
  for:
  - what
- id: replace
  source: '0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: _replaceInstance(id, oldInstance, newInstance);
  line: 186
  says: A valid proof rotates the instance to a signer-chosen address.
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
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier and SecureSgxVerifier; on-chain reads at
    block 26,431,535)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This verifier checks SGX proofs for the Taiko inbox and proof verifier, accepting one when ECDSA recovers a registered instance address. A quantum attacker who recovers an instance key signs any transition and rotates in a key of its own.

## Evidence

- [verifyProof](https://etherscan.io/address/0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5#code) requires the old instance to equal ECDSA.recover of the signed public inputs.
- [verifyProof](https://etherscan.io/address/0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5#code) replaces the instance with the signer-chosen new instance address.
- [upgradeTo](https://etherscan.io/address/0x8addcf5d4cd7bd9da1ce62ef84aee22c9e2bfba5#code) lets the admin replace the verifier code.

## Reviewer notes

### Mechanism

verifyProof (lines 148-188), callable only by taikoInbox or taikoProofVerifier (line 153), reads oldInstance and newInstance from a 109-byte proof, hashes them with LibPublicInput.hashPublicInputs per transition, and at line 180 requires oldInstance == ECDSA.recover(signatureHash, signature), which uses ecrecover (ECDSA.sol line 139). Line 183 checks the instance is registered and unexpired via _isInstanceValid; line 186 swaps in newInstance via _replaceInstance. Recovering the secp256k1 key of a registered instance from a published signature lets an attacker sign any transition and also install its own key. The owner can also add instances without attestation via addInstances (line 110). The contract is a UUPS proxy owned by TaikoDAOController.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
