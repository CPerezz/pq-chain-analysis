---
id: onlybotstoken-fcf5306e-rotate-signer-before-migrating
format: 2
title: 'OnlyBotsToken: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  name: OnlyBotsToken
  code: verified
  code_url: https://etherscan.io/address/0xfcf5306ec78088dd85bb484816a1e37161b005e6#code
  copies: 1
  upgradeable: 'no'
  admin: '0x6861080a5dd99f5633a3612cfe34487d3e578c58'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 30
impact: liveness
action: Replace the signer with setAuthSigner before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  file: OnlyBotsToken.sol
  line: 263
  has: address recoveredSigner = ecrecover(hash, _v, _r, _s);
  says: authorize recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  file: OnlyBotsToken.sol
  line: 264
  has: if (recoveredSigner != authSigner) {
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  file: OnlyBotsToken.sol
  line: 170
  has: function setAuthSigner
  says: setAuthSigner changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer
  call: '0xfcf5306ec78088dd85bb484816a1e37161b005e6'
  fn: authSigner()(address)
  is: '0xd81c1fd351b11b12ebdf8a8e2eedef076fef4343'
  says: The signer it keeps in storage is 0xd81c1fd351b11b12ebdf8a8e2eedef076fef4343 at the block
  for:
  - action
  - evidence-3
  - what
- id: signer-code
  code: '0xd81c1fd351b11b12ebdf8a8e2eedef076fef4343'
  is: empty
  says: 'the signer''s account has no code: an ECDSA key controls it'
  for:
  - action
  - evidence-3
  - justification
  - what
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

OnlyBotsToken accepts a call to authorize only with an ECDSA signature of the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setAuthSigner changes the signer.

## Evidence

- [authorize](https://etherscan.io/address/0xfcf5306ec78088dd85bb484816a1e37161b005e6#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setAuthSigner](https://etherscan.io/address/0xfcf5306ec78088dd85bb484816a1e37161b005e6#code) changes the signer; only a role holder can call it.
- The signer at the block is [0xd81c…4343](https://etherscan.io/address/0xd81c1fd351b11b12ebdf8a8e2eedef076fef4343), an account without code.

## Reviewer notes

### Mechanism

authorize (OnlyBotsToken.sol, line 250) recovers a signer on line 263 and tests it on line 264 against the signer it keeps in storage (authSigner() returns 0xd81c1fd351b11b12ebdf8a8e2eedef076fef4343). Neither isValidSignature selector is in the code, so that account is never asked. setAuthSigner (OnlyBotsToken.sol, line 170) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2023-01-01; 30 transactions called the address in the 90 days before the block. 35 different addresses were recovered on record (a wrong signature recovers a random one).
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
