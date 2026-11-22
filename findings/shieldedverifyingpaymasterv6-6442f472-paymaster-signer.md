---
id: shieldedverifyingpaymasterv6-6442f472-paymaster-signer
format: 2
title: thirdweb V6 paymaster trusts an ECDSA sponsor key a quantum attacker recovers
status: confirmed
severity: MEDIUM
justification: A recovered signer key spends the operator's gas deposit; MEDIUM as only a new paymaster deployment
  fixes it.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  name: ShieldedVerifyingPaymasterV6
  project: thirdweb
  code: verified
  code_url: https://etherscan.io/address/0x6442f4729ee8c890d310ef92845d43184a12ee6a#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6dd80d80dad8a7b687ac4d3bfde4cbd85954fc01'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 48154
impact: funds-loss
action: Deploy a paymaster that verifies sponsorship via ERC-1271 or a post-quantum scheme and move the EntryPoint
  deposit to it.
evidence_level: source
checks:
- id: c1
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/ShieldedVerifyingPaymasterV6.sol
  line: 54
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: The paymaster recovers the sponsor address with ECDSA.recover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c7
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/MultiSigner.sol
  line: 47
  has: function removeSigner(address _signer) public onlyOwner {
  says: The owner can remove a signer.
  for:
  - evidence-3
- id: c8
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/MultiSigner.sol
  line: 52
  has: function addSigner(address _signer) public onlyOwner {
  says: The owner can add a signer.
  for:
  - evidence-3
- id: s56
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/ShieldedVerifyingPaymasterV6.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 56
  says: Sponsorship is valid only if the recovered address is a registered signer.
  for:
  - evidence-1
  - justification
  - what
- id: s49
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/ShieldedVerifyingPaymasterV6.sol
  has: if (!allowAllBundlers && !isBundlerAllowed[tx.origin]) {
  line: 49
  says: The bundler allowlist is skipped when allowAllBundlers is set.
  for:
  - evidence-2
  - what
- id: s89
  source: '0x6442f4729ee8c890d310ef92845d43184a12ee6a'
  file: src/paymaster/ShieldedVerifyingPaymasterV6.sol
  has: abi.encodePacked(allowAllBundlers, validUntil, validAfter, extraData)
  line: 89
  says: The signed hash includes the allowAllBundlers flag.
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
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

This ERC-4337 paymaster sponsors a user operation when ECDSA recovers a key in its signers set from the paymaster signature. A quantum attacker who recovers a signer key signs its own operations, can set the allow-all-bundlers flag, and spends the paymaster's EntryPoint deposit as gas.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0x6442f4729ee8c890d310ef92845d43184a12ee6a#code) recovers the sponsor with ECDSA.recover and checks it against signers.
- [The signed hash](https://etherscan.io/address/0x6442f4729ee8c890d310ef92845d43184a12ee6a#code) covers the allowAllBundlers flag, so the signer chooses whether any bundler may submit.
- [addSigner](https://etherscan.io/address/0x6442f4729ee8c890d310ef92845d43184a12ee6a#code) lets the owner rotate signers, but each signer is still checked by ECDSA.

## Reviewer notes

### Mechanism

_validatePaymasterUserOp (lines 38-60) parses (allowAllBundlers, validUntil, validAfter, extraData, signature) from paymasterAndData via _parseVerifyingConfig (line 103). Line 49 skips the bundler allowlist when allowAllBundlers is set. Line 53 builds an eth-signed hash of getHash(userOp), which (lines 86-90) covers allowAllBundlers, validity window and extraData. Line 54 calls ECDSA.recover; line 56 accepts if the recovered address is in signers. The EntryPoint then charges the paymaster's deposit for gas; _postOp (line 64) emits TransactionSponsored. A quantum attacker deriving a signer's private key from its public key (exposed by any sponsored op) can sign arbitrary ops with allowAllBundlers=true and drain the deposit through its own bundler. addSigner/removeSigner (MultiSigner lines 47, 52) only swap one ECDSA key for another.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users' own funds are not spent through this path; only the paymaster's EntryPoint deposit.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
