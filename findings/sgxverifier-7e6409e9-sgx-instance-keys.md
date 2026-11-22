---
id: sgxverifier-7e6409e9-sgx-instance-keys
format: 2
title: Taiko Pacaya SGX verifier accepts ECDSA proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: A registered SGX ECDSA key authorises L2 state proofs. The Taiko DAO can fix it by upgrading verifiers.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7e6409e9b6c5e2064064a6cc994f9a2e95680782'
  name: SgxVerifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5#code
  proxy_of: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  copies: 1
  upgradeable: 'yes'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade or retire this verifier so that no proof path relies on secp256k1 SGX instance signatures.
evidence_level: source
checks:
- id: c1
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  line: 180
  has: require(oldInstance == ECDSA.recover(signatureHash, signature), SGX_INVALID_PROOF());
  says: proof accepted only if ECDSA recovers the instance address
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - evidence-1
  - what
- id: c4
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 68
  has: function upgradeTo(address newImplementation) public virtual onlyProxy {
  says: contract is UUPS-upgradeable
  for:
  - action
  - justification
- id: c5
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 83
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: upgradeToAndCall is available
  for:
  - action
- id: chk-valid
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: require(_isInstanceValid(id, oldInstance), SGX_INVALID_INSTANCE());
  line: 183
  says: signer must be a registered, unexpired instance
  for:
  - evidence-2
  - what
- id: chk-add
  source: '0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5'
  file: contracts/layer1/verifiers/SgxVerifier.sol
  has: onlyOwner
  line: 110
  says: addInstances is owner-only with no attestation
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

This SgxVerifier checks Taiko proofs by requiring a registered SGX instance address to equal the ECDSA signer of the proof's public inputs. A quantum attacker who recovers a registered instance key from its public key can sign any transition and pass this check.

## Evidence

- [verifyProof](https://etherscan.io/address/0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5#code) reverts unless ECDSA recovers the claimed instance address from the signature.
- [verifyProof](https://etherscan.io/address/0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5#code) then requires that address to be a registered, unexpired instance.
- [addInstances](https://etherscan.io/address/0xdb7aee4fa967c2ab0ec28f63c8675224e59340a5#code) lets the owner register instance keys without attestation.

## Reviewer notes

### Mechanism

verifyProof (lines 148-188) is callable from taikoInbox or taikoProofVerifier. It requires a 109-byte proof (line 157) and reads oldInstance and newInstance. It hashes the public inputs, which include LibPublicInput.hashPublicInputs for each transition (lines 163-177). It then requires oldInstance == ECDSA.recover(signatureHash, signature) (line 180, ecrecover in ECDSA.sol line 139) and _isInstanceValid (line 183: registered and within 365 days). Instances come from registerInstance (DCAP attestation, line 138) or owner-only addInstances (line 108). This proxy belongs to the retired Pacaya path (sgxGeth under MainnetVerifier). Per kev, this path is retired: post-fork Pacaya batches no longer sync state roots to SignalService, so a forged proof here releases nothing today. The live risk sits in the Shasta SecureSgxVerifiers. The admin is TaikoDAOController, which can upgrade through UUPS upgradeTo.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Pacaya path retired: SignalService checkpoints come only from the Shasta inbox (per kev)
- Ruled out: Contract holds no funds

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
