---
id: rsasignaturechecker-899cbf89-rsa-credentials
format: 2
title: Keyring RSA issuer signatures let a quantum attacker forge KYC credentials
status: confirmed
severity: LOW
justification: Forged RSA credentials bypass KYC gates without taking funds; Keyring's admin can swap the checker
  by one setting.
category: quantum-exposure
pattern: PQ-10
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  name: RSASignatureChecker
  project: keyring
  code: verified
  code_url: https://etherscan.io/address/0x899cbf89b644e79f9042c4c96fc513d31063872b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 69
impact: liveness
action: Point KeyringCore at a post-quantum signature checker, register post-quantum issuer keys and revoke the
  RSA ones.
evidence_level: source
checks:
- id: c1
  source: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  file: src/signatureCheckers/RSASignatureChecker.sol
  line: 113
  has: if iszero(staticcall(not(0), 0x05, add(input, 0x20), inputlen, add(decipher, 0x20), decipherlen)) {
  says: Signature is raised to e modulo the issuer modulus via the modexp precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c-check
  source: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  file: src/signatureCheckers/RSASignatureChecker.sol
  has: function checkSignature(
  line: 56
  says: Entry point KeyringCore calls to verify credential signatures.
  for:
  - action
  - justification
  - what
- id: c-e3
  source: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  file: src/signatureCheckers/RSASignatureChecker.sol
  has: bytes memory e = hex"03";
  line: 66
  says: RSA public exponent is fixed at 3.
  for:
  - evidence-1
  - justification
  - what
- id: c-pack
  source: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  file: src/signatureCheckers/RSASignatureChecker.sol
  has: bytes memory message = packMessage(tradingAddress, policyId, validUntil, cost, backdoor);
  line: 65
  says: Signed message covers trading address, policy, expiry and cost.
  for:
  - evidence-1
  - what
- id: c-digest
  source: '0x899cbf89b644e79f9042c4c96fc513d31063872b'
  file: src/signatureCheckers/RSASignatureChecker.sol
  has: _data := xor(_data, _sha256)
  line: 294
  says: Decoded signature must end with the message's SHA-256.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Keyring credential signatures with RSA PKCS#1 v1.5 SHA-256, exponent 3, against an issuer's modulus. A quantum attacker who factors an issuer modulus can sign credentials for any address and policy, so unapproved addresses pass Keyring's compliance check.

## Evidence

- [checkSignature](https://etherscan.io/address/0x899cbf89b644e79f9042c4c96fc513d31063872b#code) packs the credential fields and verifies them with RSA, exponent fixed at 3.
- [pkcs1Sha256](https://etherscan.io/address/0x899cbf89b644e79f9042c4c96fc513d31063872b#code) raises the signature to e modulo the issuer modulus via the modexp precompile.
- [pkcs1Sha256](https://etherscan.io/address/0x899cbf89b644e79f9042c4c96fc513d31063872b#code) accepts when the decoded block ends with the SHA-256 of the message.

## Reviewer notes

### Mechanism

KeyringCore.createCredential calls signatureChecker.checkSignature (this contract). checkSignature (lines 56-68) builds the message with packMessage(tradingAddress, policyId, validUntil, cost, backdoor), sets e = 0x03 (line 66) and calls pkcs1Sha256Raw, which hashes with sha256 (line 83) and calls pkcs1Sha256. pkcs1Sha256 requires modulus length >= 64 and equal to the signature length, runs modexp via staticcall to 0x05 (line 113), then checks 0x00 0x01, 0xff padding, the SHA-256 DigestInfo prefix and finally that the trailing 32 bytes equal the message hash (lines 292-295). Anyone who knows the factorisation of a registered issuer modulus can produce such signatures, and KeyringCore then records the credential.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The checker holds no funds; a forged credential does not release KeyringCore's fee balance.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
