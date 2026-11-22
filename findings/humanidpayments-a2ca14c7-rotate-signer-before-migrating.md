---
id: humanidpayments-a2ca14c7-rotate-signer-before-migrating
format: 2
title: 'HumanIDPayments: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  name: HumanIDPayments
  code: verified
  code_url: https://etherscan.io/address/0xa2ca14c7d625895e6939961b87ce378836ca840f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 94
  basis: held
activity:
  txs_90d: 2328
impact: liveness
action: Replace the signer with setOracleAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  file: contracts/HumanIDPayments.sol
  line: 180
  has: address signer = messageHash.toEthSignedMessageHash().recover(signature);
  says: _processPayment recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  file: contracts/HumanIDPayments.sol
  line: 181
  has: if (signer != oracleAddress) revert InvalidSignature();
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  file: contracts/HumanIDPayments.sol
  line: 319
  has: function setOracleAddress
  says: setOracleAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xa2ca14c7d625895e6939961b87ce378836ca840f'
  fn: oracleAddress()(address)
  is: '0x1f39402d34ea3024dc7f6afc6addde198332a307'
  says: The signer it keeps in storage is 0x1f39402d34ea3024dc7f6afc6addde198332a307 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x1f39402d34ea3024dc7f6afc6addde198332a307'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x74c656e000eceef066b4ecf755f325a5802e580fd1a2ffd087f2cc4aec6fd8ca'
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

HumanIDPayments checks an ECDSA signature in _processPayment and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setOracleAddress changes the signer.

## Evidence

- [_processPayment](https://etherscan.io/address/0xa2ca14c7d625895e6939961b87ce378836ca840f#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setOracleAddress](https://etherscan.io/address/0xa2ca14c7d625895e6939961b87ce378836ca840f#code) changes the signer; only a role holder can call it.
- The signer at the block is [0x1f39…a307](https://etherscan.io/address/0x1f39402d34ea3024dc7f6afc6addde198332a307), an account without code.

## Reviewer notes

### Mechanism

_processPayment (contracts/HumanIDPayments.sol, line 158) recovers a signer on line 180 and tests it on line 181 against the signer it keeps in storage (oracleAddress() returns 0x1f39402d34ea3024dc7f6afc6addde198332a307). Neither isValidSignature selector is in the code, so that account is never asked. setOracleAddress (contracts/HumanIDPayments.sol, line 319) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-18, recovering 0x1f39…a307; 2,328 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
