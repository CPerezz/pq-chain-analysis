---
id: testresources04-f8416fc2-rotate-signer-before-migrating
format: 2
title: 'TestResources04: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  name: TestResources04
  code: verified
  code_url: https://etherscan.io/address/0xf8416fc29b7aae55aeb2c31372c4de56185fb64b#code
  copies: 2
  family: 95e27db53237a430a06e948059af3abd
  upgradeable: 'no'
  admin: '0x98bb7e50ccde5b1812c88be024be3b01b3894d1f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 62
impact: liveness
action: Replace the signer with setGameSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  file: TestResources04.sol
  line: 253
  has: if (messageHash.toEthSignedMessageHash().recover(signature) != gameSigner) {
  says: _verifyAndConsumeAuth recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: setter
  source: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  file: TestResources04.sol
  line: 376
  has: function setGameSigner
  says: setGameSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xf8416fc29b7aae55aeb2c31372c4de56185fb64b'
  fn: gameSigner()(address)
  is: '0x8ec68f18704b5b31057bd805bacbe95d3b547ed4'
  says: The signer it keeps in storage is 0x8ec68f18704b5b31057bd805bacbe95d3b547ed4 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0x8ec68f18704b5b31057bd805bacbe95d3b547ed4'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0x28f7d2d9f7a1ddde81265c6bf86cf04b0d0c99635831d976b42569b504295e6c'
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

TestResources04 checks an ECDSA signature in _verifyAndConsumeAuth and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setGameSigner changes the signer.

## Evidence

- [_verifyAndConsumeAuth](https://etherscan.io/address/0xf8416fc29b7aae55aeb2c31372c4de56185fb64b#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setGameSigner](https://etherscan.io/address/0xf8416fc29b7aae55aeb2c31372c4de56185fb64b#code) changes the signer; only the owner can call it.
- The signer at the block is [0x8ec6…7ed4](https://etherscan.io/address/0x8ec68f18704b5b31057bd805bacbe95d3b547ed4), an account without code.

## Reviewer notes

### Mechanism

_verifyAndConsumeAuth (TestResources04.sol, line 244) recovers a signer on line 253 and tests it on line 253 against the signer it keeps in storage (gameSigner() returns 0x8ec68f18704b5b31057bd805bacbe95d3b547ed4). Neither isValidSignature selector is in the code, so that account is never asked. setGameSigner (TestResources04.sol, line 376) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-10-15, recovering 0x98bb…4d1f; 62 transactions called the address in the 90 days before the block. 3 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe (D-029 item 33): the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
