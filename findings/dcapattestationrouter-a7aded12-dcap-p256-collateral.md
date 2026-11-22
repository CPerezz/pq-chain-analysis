---
id: dcapattestationrouter-a7aded12-dcap-p256-collateral
format: 2
title: Jovay TEE router trusts P-256 quote signatures a quantum attacker could forge
status: confirmed
severity: LOW
justification: P-256 TEE quotes alone finalize Jovay state; the owner can also require ZK proofs, and the escrow
  is small, so LOW
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  name: DCAPAttestationRouter
  project: jovay
  code: verified
  code_url: https://etherscan.io/address/0xa7aded125cb4663c0ddb1a563d03df158b191c0b#code
  copies: 1
  upgradeable: 'no'
  admin: '0xa1e7758a84b40ba7aa1a80b3d3096e918a7950bb'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2166
impact: funds-loss
action: Require ZK proofs alongside TEE proofs with Rollup setMode(1), or switch the Rollup's TEE verifier
evidence_level: source
checks:
- id: c1
  source: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  file: src/TEECacheVerifier.sol
  line: 219
  has: bool success = P256Verifier.ecdsaVerify(sha256(localAttestationData), ecdsa256BitSignature, ecdsaAttestationKey);
  says: V3 quotes are accepted on a P-256 ECDSA check
  for:
  - what
- id: c2
  source: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  file: src/TEECacheVerifier.sol
  line: 253
  has: bool success = P256Verifier.ecdsaVerify(sha256(localAttestationData), ecdsa256BitSignature, ecdsaAttestationKey);
  says: V4 quotes are accepted on a P-256 ECDSA check
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  file: src/TEECacheVerifier.sol
  line: 292
  has: bool success = P256Verifier.ecdsaVerify(sha256(localAttestationData), ecdsa256BitSignature, ecdsaAttestationKey);
  says: V5 quotes are accepted on a P-256 ECDSA check
  for:
  - evidence-3
  - what
- id: c4
  source: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  file: ../libraries/lib/automata-dcap-attestation/evm/contracts/utils/P256Verifier.sol
  line: 22
  has: function ecdsaVerify(bytes32 messageHash, bytes memory signature, bytes memory key)
  says: ecdsaVerify takes a message hash, signature and key
  for:
  - evidence-2
  - what
- id: c5
  source: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  file: ../libraries/lib/automata-dcap-attestation/evm/contracts/utils/P256Verifier.sol
  line: 34
  has: (bool success, bytes memory ret) = P256_VERIFIER.staticcall(args);
  says: ecdsaVerify calls the P256_VERIFIER
  for:
  - action
  - evidence-2
  - justification
  - what
- id: code
  code: '0xa7aded125cb4663c0ddb1a563d03df158b191c0b'
  is: contract
  bytes: 5072
  says: The address holds contract code
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), filed under daimo-p256-verifier
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

This contract checks Intel TEE attestation quotes for Jovay's rollup. It accepts a quote when a P-256 ECDSA signature over the quote verifies against the attestation key. A quantum attacker who recovers that key can sign a forged quote carrying a commitment of their choice.

## Evidence

- [_verifyQuoteV4](https://etherscan.io/address/0xa7aded125cb4663c0ddb1a563d03df158b191c0b#code) accepts a quote only if ecdsaVerify succeeds on the attestation key.
- [ecdsaVerify](https://etherscan.io/address/0xa7aded125cb4663c0ddb1a563d03df158b191c0b#code) passes the signature and key to the P256_VERIFIER through a staticcall.
- [_verifyQuoteV5](https://etherscan.io/address/0xa7aded125cb4663c0ddb1a563d03df158b191c0b#code) uses the same P-256 check for TDX version 5 quotes.

## Reviewer notes

### Mechanism

verifyAndAttestOnChain dispatches by quote version to _verifyQuoteV3, _verifyQuoteV4 or _verifyQuoteV5 (lines 219, 253, 292). Each hashes the header and body with sha256. Each calls P256Verifier.ecdsaVerify (line 22) with the quote's 64-byte signature and 64-byte attestation key. ecdsaVerify does a staticcall to P256_VERIFIER (line 34). On success, the function returns the 32-byte commitment taken from the report data. Per kev, Jovay's Rollup in mode 0 finalizes a batch on this commitment alone. Cached keys are managed by addKey, deleteKey and clearCache under owner or authorized control. Uncached quotes go through Automata's quote verifiers, which check Intel's PCK chain and collateral with P-256 (SigVerifyBase.verifySignature, line 38).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds itself
- Ruled out: How keys enter the cache was not traced

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
