---
id: securesgxverifier-9d3c595b-sgx-instance-keys
format: 2
title: Taiko SGX_RETH verifier accepts ECDSA enclave keys a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Proof acceptance rests on a secp256k1 enclave key; Taiko DAO can replace the verifier by upgrade.
  MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  name: SecureSgxVerifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8#code
  copies: 1
  upgradeable: 'no'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4
impact: funds-loss
action: Replace the ECDSA-signed SGX verifier with a post-quantum proof scheme through a Taiko DAO upgrade of the
  inbox and verifiers.
evidence_level: source
checks:
- id: c1
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  line: 187
  has: require(instance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  says: Proof accepted only if ECDSA recovers the registered instance address.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover uses the secp256k1 ecrecover precompile.
  for:
  - evidence-1
  - what
- id: c3
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: node_modules/@openzeppelin/contracts/access/Ownable2Step.sol
  line: 35
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: Ownership is held by an owner that can manage the verifier.
  for:
  - action
  - justification
- id: s-inst
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: address instance = address(bytes20(_proof[4:24]));
  line: 178
  says: Instance address is read from the proof bytes.
  for:
  - evidence-2
- id: s-valid
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: require(_isInstanceValid(id, instance), SGX_INVALID_INSTANCE());
  line: 179
  says: Instance must be registered and unexpired.
  for:
  - evidence-2
  - what
- id: s-add
  source: '0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: return _addInstances(_instances, true);
  line: 117
  says: Owner-only addInstances registers keys without attestation.
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
reviews: []
related: []
---

## What happens

This SGX_RETH verifier accepts a proof when ECDSA recovers a registered enclave instance address from its signature over the proof inputs. A quantum attacker who recovers the instance key can sign any state transition, which together with a forged ZK proof finalizes a false L2 state.

## Evidence

- [verifyProof](https://etherscan.io/address/0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8#code) requires the instance to equal ECDSA.recover of the signature over the public-input hash.
- [verifyProof](https://etherscan.io/address/0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8#code) takes the instance address and id from the proof and checks it is registered and unexpired.
- [addInstances](https://etherscan.io/address/0x9d3c595bff6ff7d2b2cbdecf94ad917eb2fcffd8#code) lets the owner register instance keys with no attestation.

## Reviewer notes

### Mechanism

SgxVerifier.verifyProof (lines 167-188) requires an 89-byte proof: 4-byte id, 20-byte instance address, 65-byte signature. _isInstanceValid (231-236) checks the instance is registered under that id and within INSTANCE_EXPIRY. The signature hash is LibPublicInput.hashPublicInputs(aggregatedProvingHash, this, instance, taikoChainId), and line 187 requires instance == ECDSA.recover(...), which uses ecrecover (ECDSA.sol line 139). Instances enter via registerInstance (registrar-gated, Automata DCAP attestation, itself P-256) or owner-only addInstances (no attestation). The instance key signs every proof, exposing its public key. The ZkRequiredVerifier composes this SGX_RETH sub-proof with a RISC Zero or SP1 BN254 proof, also quantum-forgeable, so a forged pair lets Inbox.prove save a false checkpoint that the L1 Bridge and vaults trust. Kev's finding records SGX_RETH unused in the last 30 days of proofs, but it stays an accepted sub-verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Retired Pacaya SGX verifiers release nothing: SignalService accepts checkpoints only from the Shasta inbox.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
