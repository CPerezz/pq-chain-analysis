---
id: singletonpaymasterv6-66666666-paymaster-signer
format: 2
title: Pimlico V6 paymaster trusts ECDSA sponsor signatures a quantum attacker forges
status: confirmed
severity: MEDIUM
justification: Sponsorship rests on ECDSA signer keys; rotating signers keeps ECDSA, so Pimlico must deploy a new
  paymaster.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6666666666667849c56f2850848ce1c4da65c68b'
  name: SingletonPaymasterV6
  project: pimlico
  code: verified
  code_url: https://etherscan.io/address/0x6666666666667849c56f2850848ce1c4da65c68b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 27888
impact: funds-loss
action: Deploy a paymaster verifying sponsorship via ERC-1271 or a post-quantum scheme, move the deposit and point
  the API at it.
evidence_level: source
checks:
- id: c1
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/SingletonPaymasterV6.sol
  line: 151
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: Verifying mode recovers the sponsor with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/SingletonPaymasterV6.sol
  line: 179
  has: address recoveredSigner = ECDSA.recover(hash, cfg.signature);
  says: ERC-20 mode recovers the sponsor with ECDSA.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: lib/openzeppelin-contracts-v5.0.2/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - what
- id: c5
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/base/MultiSigner.sol
  line: 43
  has: function removeSigner(address _signer) public onlyAdminOrManager {
  says: Admin or manager removes signers.
  for:
  - evidence-3
  - justification
- id: c6
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/base/MultiSigner.sol
  line: 48
  has: function addSigner(address _signer) public onlyAdminOrManager {
  says: Admin or manager adds signers.
  for:
  - evidence-3
  - justification
- id: sig1
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/SingletonPaymasterV6.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 153
  says: Verifying mode accepts when the recovered address is in signers.
  for:
  - evidence-1
  - what
- id: sig2
  source: '0x6666666666667849c56f2850848ce1c4da65c68b'
  file: src/SingletonPaymasterV6.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 181
  says: ERC-20 mode accepts when the recovered address is in signers.
  for:
  - evidence-2
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

This ERC-4337 paymaster sponsors a user operation when ECDSA recovers a key from its signers set. A quantum attacker who derives a signer key signs its own operations, and the EntryPoint pays their gas from this paymaster's deposit.

## Evidence

- [_validateVerifyingMode](https://etherscan.io/address/0x6666666666667849c56f2850848ce1c4da65c68b#code) accepts an operation when the ECDSA-recovered address is a listed signer.
- [_validateERC20Mode](https://etherscan.io/address/0x6666666666667849c56f2850848ce1c4da65c68b#code) uses the same ECDSA recovery against the signers set.
- [addSigner and removeSigner](https://etherscan.io/address/0x6666666666667849c56f2850848ce1c4da65c68b#code) only swap one ECDSA signer for another.

## Reviewer notes

### Mechanism

validatePaymasterUserOp (line 50) calls _validatePaymasterUserOp, which dispatches by mode. _validateVerifyingMode computes toEthSignedMessageHash(getHash(VERIFYING_MODE, userOp)) (line 150), calls ECDSA.recover (line 151, ecrecover in OpenZeppelin tryRecover line 142) and sets isSignatureValid = signers[recoveredSigner] (line 153), packed into validationData. _validateERC20Mode does the same at lines 178-181. With a valid signature the EntryPoint v0.6 charges the operation's gas to this paymaster's deposit. In ERC-20 mode the tokens come from userOp.sender (line 196), so a forged exchange rate only lowers the attacker's own payment while the deposit pays the gas. Signers are managed by addSigner/removeSigner (onlyAdminOrManager), which keep ECDSA, so rotation alone does not fix it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Tokens held by users are not moved by a forged sponsor signature; ERC-20 transfers come from the operation's own sender.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
