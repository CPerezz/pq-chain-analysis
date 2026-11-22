---
id: inputverifier-ce0fc2e0-coprocessor-signers
format: 2
title: Zama FHEVM trusts coprocessor ECDSA keys that a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: Forged coprocessor ECDSA signatures pass input checks; MEDIUM because the ACL owner can upgrade the
  verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xce0fc2e05cfff1b719eff7169f7d80af770c8ea2'
  name: InputVerifier
  project: zama
  code: verified
  code_url: https://etherscan.io/address/0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6#code
  proxy_of: '0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 37536
impact: liveness
action: Upgrade InputVerifier to verify post-quantum coprocessor signatures; rotating ECDSA signers alone does not
  fix it.
evidence_level: source
checks:
- id: c1
  source: '0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6'
  file: contracts/InputVerifier.sol
  line: 520
  has: address signerRecovered = ECDSA.recover(message, signature);
  says: _recoverSigner recovers the coprocessor signer with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover ends in the ecrecover precompile.
  for:
  - what
- id: upg
  source: '0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6'
  file: contracts/InputVerifier.sol
  has: function _authorizeUpgrade(address _newImplementation) internal virtual override onlyACLOwner {}
  line: 552
  says: Upgrades are authorized only for the ACL owner.
  for:
  - action
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review09 (finding review)
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

InputVerifier accepts encrypted user inputs for FHEVM applications when coprocessor signatures, recovered with ECDSA, come from registered signers. A quantum attacker who recovers enough coprocessor keys can get arbitrary ciphertext handles accepted as a user's input without a proof of knowledge.

## Evidence

- [_recoverSigner](https://etherscan.io/address/0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6#code) recovers each coprocessor signer with ECDSA.recover.
- [_authorizeUpgrade](https://etherscan.io/address/0xc4a1a1bae73ca6aceb2faa62ce08bfabcd2323b6#code) lets the ACL owner upgrade the verifier.

## Reviewer notes

### Mechanism

FHEVMExecutor calls InputVerifier.verifyInput(context, inputHandle, inputProof) when an application takes an encrypted input. The proof carries handles and 65-byte coprocessor signatures over an EIP-712 CiphertextVerification digest. That digest binds the handles, the user, the contract and the chain id. _verifySignaturesDigest passes each signature to _recoverSigner (l.519-520), which calls ECDSA.recover, ending in ecrecover (ECDSA.sol l.148). Each recovered address must be a registered signer, and the check requires at least getThreshold() distinct signers. The ACL owner rotates signers and threshold through defineNewContext and setThreshold. Upgrades go through _authorizeUpgrade (l.552). All three are onlyACLOwner. An attacker who recovers a threshold of coprocessor keys can attest arbitrary handles for any user and application.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself.
- Ruled out: The underlying FHE scheme is lattice-based and is not the issue.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
