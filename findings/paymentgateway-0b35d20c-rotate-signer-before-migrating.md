---
id: paymentgateway-0b35d20c-rotate-signer-before-migrating
format: 2
title: 'PaymentGateway: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  name: PaymentGateway
  code: verified
  code_url: https://etherscan.io/address/0x0b35d20c9b45f1312f408768bee75150b2b8a80e#code
  copies: 1
  upgradeable: 'no'
  admin: '0xef16618254340dcdbba23540dc58938b96616893'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 149
impact: liveness
action: Replace the signer with updateSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  file: src/PaymentGateway.sol
  line: 250
  has: address recovered = ECDSA.recover(digest, signature);
  says: _verifyPayment recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  file: src/PaymentGateway.sol
  line: 251
  has: if (recovered == address(0)) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  file: src/PaymentGateway.sol
  line: 167
  has: function updateSigner
  says: updateSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0x0b35d20c9b45f1312f408768bee75150b2b8a80e'
  fn: getSigner()(address)
  is: '0x0986ad674f9d0b9af3e6895bdceeb3c7a71e4007'
  says: The signer it keeps in storage is 0x0986ad674f9d0b9af3e6895bdceeb3c7a71e4007 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x0986ad674f9d0b9af3e6895bdceeb3c7a71e4007'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x2cab3c6f16fd6a85b7468ad44dfa30e3d7a26aee954f11547a1edade7a41026b'
  ok: true
  says: a transaction in which this contract recovered a signature
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

PaymentGateway checks an ECDSA signature in _verifyPayment and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. updateSigner changes the signer.

## Evidence

- [_verifyPayment](https://etherscan.io/address/0x0b35d20c9b45f1312f408768bee75150b2b8a80e#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [updateSigner](https://etherscan.io/address/0x0b35d20c9b45f1312f408768bee75150b2b8a80e#code) changes the signer; only the owner can call it.
- The signer at the block is [0x0986…4007](https://etherscan.io/address/0x0986ad674f9d0b9af3e6895bdceeb3c7a71e4007), an account without code.

## Reviewer notes

### Mechanism

_verifyPayment (src/PaymentGateway.sol, line 223) recovers a signer on line 250 and tests it on line 251 against the signer it keeps in storage (getSigner() returns 0x0986ad674f9d0b9af3e6895bdceeb3c7a71e4007). Neither isValidSignature selector is in the code, so that account is never asked. updateSigner (src/PaymentGateway.sol, line 167) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x0986…4007; 149 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
