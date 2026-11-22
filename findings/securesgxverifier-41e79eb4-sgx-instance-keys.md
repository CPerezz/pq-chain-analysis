---
id: securesgxverifier-41e79eb4-sgx-instance-keys
format: 2
title: Taiko SGX verifier trusts ECDSA enclave keys a quantum attacker could recover
status: confirmed
severity: MEDIUM
justification: Enclave ECDSA keys sign every L1 proof; the Taiko DAO owns the verifiers and can replace them by
  upgrade. MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  name: SecureSgxVerifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee#code
  copies: 1
  upgradeable: 'no'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4065
impact: funds-loss
action: Upgrade the inbox and verifier set so no proof path relies on ECDSA enclave keys or BN254 proofs alone.
evidence_level: source
checks:
- id: c1
  source: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  line: 187
  has: require(instance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  says: verifyProof accepts only if ECDSA recovers the instance address.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA recovery uses the secp256k1 ecrecover precompile.
  for:
  - evidence-2
  - what
- id: c3
  source: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  file: node_modules/@openzeppelin/contracts/access/Ownable2Step.sol
  line: 35
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: The contract is Ownable2Step; ownership is owner-controlled.
  for:
  - action
  - justification
- id: v-instance
  source: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: require(_isInstanceValid(id, instance), SGX_INVALID_INSTANCE());
  line: 179
  says: verifyProof requires a registered, unexpired instance.
  for:
  - what
- id: reg-addr
  source: '0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: addresses[0] = address(bytes20(_attestation.localEnclaveReport.reportData));
  line: 161
  says: The registered instance address comes from the attested report data.
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

This verifier accepts an SGX proof when ECDSA recovers a registered, unexpired enclave address from its signature over the proof's public inputs. With a quantum computer, an attacker can recover a registered enclave key from its public key and sign a false state transition that this check accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee#code) requires the instance address to equal ECDSA.recover of the signature hash.
- [ECDSA.tryRecover](https://etherscan.io/address/0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee#code) calls the secp256k1 ecrecover precompile.
- [registerInstance](https://etherscan.io/address/0x41e79eb4f03abb5df8716b759528dc5d8f6a84ee#code) stores the enclave address taken from the attested report data.

## Reviewer notes

### Mechanism

SgxVerifier.verifyProof (lines 167-188) takes an 89-byte proof: 4-byte id, 20-byte instance address, 65-byte signature. _isInstanceValid (231-236) checks the address is registered under that id and within INSTANCE_EXPIRY. The signature hash is LibPublicInput.hashPublicInputs(aggregatedProvingHash, this, instance, taikoChainId), and line 187 requires instance == ECDSA.recover(...), which reaches ecrecover (ECDSA.sol line 139). Instances enter via registerInstance (registrar-gated, DCAP attestation, address from reportData line 161) or owner-only addInstances (112-118). Because the enclave key signs every proof, its public key is exposed; a CRQC recovers it and signs any commitment. Per kev, the ZkRequiredVerifier also requires a RISC Zero or SP1 BN254 proof, which the same attacker can forge, so the composed proof finalizes a false L2 state that releases L1 Bridge and vault funds. The owner (TaikoDAOController) can delete instances and the DAO can replace the verifiers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself; loss occurs through the bridge and vaults downstream.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
