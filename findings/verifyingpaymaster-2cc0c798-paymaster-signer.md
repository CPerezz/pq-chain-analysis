---
id: verifyingpaymaster-2cc0c798-paymaster-signer
format: 2
title: Alchemy paymaster deposit open to a quantum-forged ECDSA sponsor signature
status: confirmed
severity: MEDIUM
justification: One ECDSA key authorizes spending the deposit; Alchemy can fix it by a UUPS upgrade, so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2cc0c7981d846b9f2a16276556f6e8cb52bfb633'
  name: VerifyingPaymaster
  project: alchemy
  code: verified
  code_url: https://etherscan.io/address/0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4#code
  proxy_of: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  copies: 1
  upgradeable: 'yes'
  admin: '0xddf32240b4ca3184de7ec8f0d5aba27dec8b7a5c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 273358
impact: funds-loss
action: Upgrade the implementation so that it verifies sponsor signatures with a post-quantum scheme.
evidence_level: source
checks:
- id: c1
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: src/VerifyingPaymaster.sol
  line: 221
  has: if (verifyingSigner != hash.toEthSignedMessageHash().recover(paymasterData)) {
  says: The standard sponsorship succeeds only if ECDSA recovers verifyingSigner.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: src/VerifyingPaymaster.sol
  line: 289
  has: if (verifyingSigner != hash.toEthSignedMessageHash().recover(signature)) {
  says: Permit-mode sponsorship uses the same ECDSA signer check.
  for:
  - what
- id: c3
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: src/VerifyingPaymaster.sol
  line: 333
  has: if (verifyingSigner != hash.toEthSignedMessageHash().recover(signature)) {
  says: Pre-approval and post-op modes use the same ECDSA signer check.
  for:
  - what
- id: c4
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: Signer recovery uses the ecrecover precompile.
  for:
  - evidence-2
  - what
- id: c7
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol
  line: 92
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: The contract can be upgraded through UUPS upgradeToAndCall.
  for:
  - action
  - justification
- id: rotate
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: src/VerifyingPaymaster.sol
  has: function updateVerifyingSigner(address newVerifyingSigner) external onlyOwner {
  line: 112
  says: The owner can replace the signer only with another address.
  for:
  - evidence-3
- id: auth-upgrade
  source: '0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4'
  file: src/VerifyingPaymaster.sol
  has: onlyOwner
  line: 408
  says: Upgrades are authorized by the owner alone.
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

Alchemy's paymaster pays gas for a user operation when the paymaster data carries an ECDSA signature that recovers to verifyingSigner. A quantum attacker who derives that key from a published signature can sign sponsorships for any operation and spend the paymaster's EntryPoint deposit.

## Evidence

- [_validatePaymasterUserOp](https://etherscan.io/address/0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4#code) returns a failed validation unless the recovered signer equals verifyingSigner.
- [ECDSA tryRecover](https://etherscan.io/address/0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4#code) gets the signer from the ecrecover precompile.
- [updateVerifyingSigner](https://etherscan.io/address/0xb4e809ab8e9990ab0465a2edb80a907aa5c2a3e4#code) lets the owner swap in another address, which is again checked with ECDSA.

## Reviewer notes

### Mechanism

EntryPoint v0.7 calls validatePaymasterUserOp, which leads to _validatePaymasterUserOp. In the standard 65-byte mode, getHash (line 217) hashes the operation fields. Line 221 compares verifyingSigner with hash.toEthSignedMessageHash().recover(paymasterData). On a match it returns sigTimeRange, and the EntryPoint charges the gas to the paymaster's deposit. The ERC-20 modes run the same check at lines 289 and 333. recover goes through tryRecover, which calls ecrecover (ECDSA.sol line 148). updateVerifyingSigner (line 112, onlyOwner) only replaces the signer address. _authorizeUpgrade (line 403, onlyOwner) gates upgradeToAndCall, which is the fix path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users' own funds are not spent through the sponsorship check; the attacker spends the paymaster's deposit on gas.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
