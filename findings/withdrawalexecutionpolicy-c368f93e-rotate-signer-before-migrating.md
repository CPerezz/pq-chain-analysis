---
id: withdrawalexecutionpolicy-c368f93e-rotate-signer-before-migrating
format: 2
title: 'This contract: replace a signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  name: WithdrawalExecutionPolicy
  code: verified
  code_url: https://etherscan.io/address/0xc368f93e2a3b24e4f41e26166613ee530d921b56#code
  copies: 4
  family: 1fc641d4e8547e7f05e0652df40fca93
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 145
impact: liveness
action: Before a signer's account moves to real code, use addSigner so that another key can sign in its place.
evidence_level: source
checks:
- id: recover
  source: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  file: src/policies/WithdrawalExecutionPolicy.sol
  line: 366
  has: signer = _recoverSigner(withdrawalExecution, signedFee);
  says: _verifySignedFee recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  file: src/policies/WithdrawalExecutionPolicy.sol
  line: 367
  has: require(_isSigner[signer], InvalidSignature());
  says: the recovered address must be an address on the signer list it keeps
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xc368f93e2a3b24e4f41e26166613ee530d921b56'
  file: src/policies/WithdrawalExecutionPolicy.sol
  line: 262
  has: function addSigner
  says: addSigner changes who may sign
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0x60be53bbd9ec0afa17123d8099dc45810cc14d26'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
  - what
- id: signed-tx
  tx: '0xe1c1ce1c211b67e776dbe2b1bfbe37561a11151714edbea1226a0fcbd4ab929b'
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

This contract checks an ECDSA signature in _verifySignedFee and accepts only an address on the signer list it keeps. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. addSigner changes who may sign.

## Evidence

- [_verifySignedFee](https://etherscan.io/address/0xc368f93e2a3b24e4f41e26166613ee530d921b56#code) recovers the signature with ECDSA and accepts only an address on the signer list it keeps; the code never asks that account.
- [addSigner](https://etherscan.io/address/0xc368f93e2a3b24e4f41e26166613ee530d921b56#code) changes who may sign (through _setSigner).
- Its latest signed [transaction](https://etherscan.io/tx/0xe1c1ce1c211b67e776dbe2b1bfbe37561a11151714edbea1226a0fcbd4ab929b) on record recovered [0x60be…4d26](https://etherscan.io/address/0x60be53bbd9ec0afa17123d8099dc45810cc14d26), an account without code.

## Reviewer notes

### Mechanism

_verifySignedFee (src/policies/WithdrawalExecutionPolicy.sol, line 357) recovers a signer on line 366 and tests it on line 367 against an address on the signer list it keeps. Neither isValidSignature selector is in the code, so that account is never asked. _setSigner (src/policies/WithdrawalExecutionPolicy.sol, line 318) writes it, called by addSigner. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2026-11-17, recovering 0x60be…4d26; 145 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
