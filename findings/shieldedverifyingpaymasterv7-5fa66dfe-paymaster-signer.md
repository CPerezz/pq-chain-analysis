---
id: shieldedverifyingpaymasterv7-5fa66dfe-paymaster-signer
format: 2
title: thirdweb V7 paymaster sponsors operations a quantum attacker could sign
status: confirmed
severity: MEDIUM
justification: Signer key is ECDSA; a quantum attacker can drain the gas deposit. Only a new deployment by the operator
  fixes it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab'
  name: ShieldedVerifyingPaymasterV7
  project: thirdweb
  code: verified
  code_url: https://etherscan.io/address/0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 173
impact: funds-loss
action: Deploy a paymaster that verifies sponsorship via ERC-1271 or a post-quantum scheme and move the deposit.
evidence_level: source
checks:
- id: c1
  source: '0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab'
  file: src/paymaster/ShieldedVerifyingPaymasterV7.sol
  line: 58
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: ECDSA.recover yields the sponsoring signer in _validatePaymasterUserOp.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: s-signers
  source: '0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab'
  file: src/paymaster/ShieldedVerifyingPaymasterV7.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 60
  says: Sponsorship is valid when the recovered address is in signers.
  for:
  - evidence-2
  - justification
  - what
- id: s-allow
  source: '0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab'
  file: src/paymaster/ShieldedVerifyingPaymasterV7.sol
  has: if (!allowAllBundlers && !isBundlerAllowed[tx.origin]) {
  line: 53
  says: The bundler allowlist is skipped when allowAllBundlers is set.
  for:
  - evidence-3
  - what
- id: s-hash
  source: '0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab'
  file: src/paymaster/ShieldedVerifyingPaymasterV7.sol
  has: abi.encodePacked(allowAllBundlers, validUntil, validAfter, extraData)
  line: 91
  says: The signed hash covers the allowAllBundlers flag.
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This ERC-4337 paymaster sponsors a user operation when ECDSA recovers a signer in its signers set from the paymaster signature. A quantum attacker who derives a signer's key signs its own operations, sets allowAllBundlers, and spends the paymaster's EntryPoint deposit as gas.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab#code) recovers the signer with ECDSA.recover.
- [_validatePaymasterUserOp](https://etherscan.io/address/0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab#code) marks the signature valid if the recovered address is in signers.
- [_validatePaymasterUserOp](https://etherscan.io/address/0x5fa66dfe8a3983e55071e8c4631ab43b5f33a4ab#code) skips the bundler allowlist when the signed allowAllBundlers flag is set.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (lines 43-64) decodes (allowAllBundlers, validUntil, validAfter, extraData, signature) via _parseVerifyingConfig. Line 53 enforces the bundler allowlist unless allowAllBundlers is set. Line 57 hashes getHash(userOp), which covers allowAllBundlers (line 91), with the eth-signed prefix. Line 58 runs ECDSA.recover, and line 60 checks signers[recoveredSigner]. The EntryPoint then charges the paymaster's deposit for gas. The owner can add and remove signers (MultiSigner addSigner/removeSigner), but each signer is an address checked by ecrecover. A quantum attacker who recovers a signer's private key from its public key can produce valid sponsorships for any operation.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users' funds are not at risk through this check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
